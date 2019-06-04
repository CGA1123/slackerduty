# frozen_string_literal: true

require 'bugsnag/api'
require_relative './base'

module Slackerduty
  module Integrations
    class Bugsnag < Base
      SUMMARY_TAG = 'Bugsnag'

      def self.api_client
        @api_client ||= ::Bugsnag::Api::Client.new(
          auth_token: ENV.fetch('BUGSNAG_API_TOKEN')
        )
      end

      def to_slack
        url = bugsnag_error['html_url']
        service = incident.dig('service', 'summary')
        context = bugsnag_error['context']
        file = bugsnag_error.dig('grouping_fields', 'file')
        line_number = bugsnag_error.dig('grouping_fields', 'lineNumber')
        error_class = bugsnag_error['error_class']
        error_message = bugsnag_error['message'].strip

        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(
            text: <<~BUGSNAG
              :cloud: <#{url}|[#{service}] #{context}>
              :memo: `#{file}:#{line_number}`
              ```
              #{error_class}: #{error_message.truncate(500)}
              ```
            BUGSNAG
          )
        end
      end

      private

      def bugsnag_error
        return @bugsnag_error if defined?(@bugsnag_error)

        regex = %r{https://app.bugsnag.com/(?<org_slug>.*)/(?<project_slug>.*)/errors/(?<error_id>[a-zA-Z0-9]+)(\?.*)?}

        url = alert['body']['details']['url']
        matches = url.match(regex)

        @bugsnag_error = error(matches[:org_slug], matches[:project_slug], matches[:error_id], url)
      end

      def client
        self.class.api_client
      end

      def error(org_slug, project_slug, error_id, url)
        project_id = projects(org_slug).fetch(project_slug)

        cached_value = redis_client.get("bugsnag_#{project_slug}_#{error_id}")

        return JSON.parse(cached_value) if cached_value

        error =
          client
          .error(project_id, error_id)
          .to_h
          .merge(html_url: url)
          .as_json

        redis_client.setex("bugsnag_#{project_slug}_#{error_id}", 60 * 5, error.to_json)

        error
      end

      def redis_client
        @redis_client = Sidekiq.redis(&:itself)
      end

      def organisation_id(org_slug)
        cached_value = redis_client.get('bugsnag_organisation_id')

        return cached_value if !cached_value.nil? && !cached_value.empty?

        org_id =
          client
          .organizations
          .find { |o| o[:slug] == org_slug }
          .then { |o| Hash(o)[:id] }

        redis_client.set('bugsnag_organisation_id', org_id)
        redis_client.expire('bugsnag_organisation_id', 60 * 60)

        org_id
      end

      def projects(org_slug)
        cached_value = redis_client.hgetall('bugsnag_projects')

        return cached_value if cached_value&.any?

        org_id = organisation_id(org_slug)

        projects =
          client
          .projects(org_id, per_page: 100)
          .map { |p| [p[:slug], p[:id]] }

        redis_client.multi do
          redis_client.del('bugsnag_projects')
          redis_client.hmset('bugsnag_projects', *projects.flatten)
          redis_client.expire('bugsnag_projects', 60 * 60)
        end

        projects.to_h
      end
    end
  end
end
