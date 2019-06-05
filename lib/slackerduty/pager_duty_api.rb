# frozen_string_literal: true

module Slackerduty
  module PagerDutyApi
    module_function

    def client
      @client ||= Faraday.new(url: 'https://api.pagerduty.com') do |conn|
        conn.token_auth Slackerduty::PAGERDUTY_TOKEN
        conn.request :json
        conn.headers[:accept] = 'application/vnd.pagerduty+json;version=2'
        conn.response :raise_error
        conn.response :json
        conn.adapter :typhoeus
      end
    end

    def incident(incident_id)
      client.get("/incidents/#{incident_id}")
    end

    def alerts(incident_id)
      client.get("/incidents/#{incident_id}/alerts")
    end

    def log_entries(incident_id)
      client.get("/incidents/#{incident_id}/log_entries")
    end

    def acknowledge(incident_id, incident_type, email)
      update_status('acknowledged', incident_id, incident_type, email)
    end

    def resolve(incident_id, incident_type, email)
      update_status('resolved', incident_id, incident_type, email)
    end

    def fetch_users(query)
      client.get("/users?query=#{query}")
    end

    def escalation_policies
      client.get('/escalation_policies')
    end

    def escalation_policy(policy_id)
      client.get("/escalation_policies/#{policy_id}")
    end

    private

    def update_status(status, incident_id, incident_type, email)
      client.put(
        "/incidents/#{incident_id}",
        {
          incident: {
            status: status,
            type: incident_type
          }
        },
        from: email
      )
    end
  end
end
