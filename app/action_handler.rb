# frozen_string_literal: true

module ActionHandler
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  attr_reader :context

  def initialize(context)
    @context = context
  end

  def body
    body = context.request.body
    body.rewind
    body.gets
  end

  def with_slack_verification
    # https://api.slack.com/docs/verifying-requests-from-slack
    timestamp = context.env['HTTP_X_SLACK_REQUEST_TIMESTAMP']
    data = "v0:#{timestamp}:#{body}"
    ours = "v0=#{OpenSSL::HMAC.hexdigest('SHA256', Slackerduty::SLACK_SIGNING_SECRET, data)}"
    theirs = context.env['HTTP_X_SLACK_SIGNATURE']

    if Rack::Utils.secure_compare(theirs, ours)
      yield
    else
      401
    end
  end

  module ClassMethods
    def call(context)
      new(context).call
    end
  end
end
