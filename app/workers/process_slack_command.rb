# frozen_string_literal: true

module Workers
  class ProcessSlackCommand
    include Sidekiq::Worker

    sidekiq_options queue: :slackerduty, retry: true, backtrace: 5

    def perform(params)
      subcommand = params['text'].split(' ').first

      command =
        case subcommand
        when 'ping'
          Slackerduty::Commands::Ping
        when 'help'
          Slackerduty::Commands::Help
        when 'link'
          Slackerduty::Commands::Register
        when 'on'
          Slackerduty::Commands::On
        when 'off'
          Slackerduty::Commands::Off
        when 'policies'
          Slackerduty::Commands::Policies
        when 'sub'
          Slackerduty::Commands::Subscribe
        when 'unsub'
          Slackerduty::Commands::Unsubscribe
        when 'subbed'
          Slackerduty::Commands::Subscriptions
        when 'incidents'
          # Slackerduty::Commands::Incidents
          Slackerduty::Commands::Wip
        when 'incident'
          # Slackerduty::Commands::Incident
          Slackerduty::Commands::Wip
        else
          Slackerduty::Commands::Unknown
        end

      command.call(params)
    end
  end
end
