# frozen_string_literal: true

module Api
  module Controllers
    module Webhooks
      module SlackVerification
        def verify_slack_signature(params)
          halt 401 unless signatures_match?(params)
        end

        def signatures_match?(params)
          theirs = params.env['HTTP_X_SLACK_SIGNATURE']
          timestamp = params.env['HTTP_X_SLACK_REQUEST_TIMESTAMP']
          data = "v0:#{timestamp}:#{request_body(params)}"
          ours = "v0=#{OpenSSL::HMAC.hexdigest('SHA256', Slackerduty::SLACK_SIGNING_SECRET, data)}"

          Rack::Utils.secure_compare(theirs.to_s, ours.to_s)
        end

        def request_body(params)
          body_io = params.env['rack.input']
          body_io.rewind
          body = body_io.read
          body_io.rewind

          body
        end
      end
    end
  end
end
