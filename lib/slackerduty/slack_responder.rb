# frozen_string_literal: true

module Slackerduty
  module SlackResponder
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    attr_accessor :response_url

    def initialize(params)
      @params = params
      @response_url = params['response_url']
    end

    def args
      @args ||= @params['text'].split(' ').drop(1)
    end

    def respond
      Net::HTTP.post(
        URI(response_url),
        payload.to_json,
        'Content-Type' => 'application/json'
      )
    end

    def payload
      @payload || default_payload
    end

    def linked_user_only
      @user = Models::User.find_by(slack_id: @params['user_id'])

      if @user
        yield
      else
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          text: <<~MESSAGE
            You haven't linked your PagerDuty account yet! :parrot-sad:
            Try: `/slackerduty link`
          MESSAGE
        ).as_json

        respond
      end
    end

    def default_payload
      Slack::BlockKit::Composition::Mrkdwn.new(
        text: <<~MESSAGE
          Woops, something bad happened! :face_with_head_bandage:
          Best to let <@UB52FFRT5> know
        MESSAGE
      ).as_json
    end

    module ClassMethods
      def call(params)
        new(params).execute
      end
    end
  end
end
