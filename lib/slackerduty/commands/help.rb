# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Commands
    class Help
      include Hanami::Interactor

      expose(:message)

      def call(_user, _organisation, _args)
        @message = <<~MESSAGE
          ```
          slackerduty v#{Slackerduty::VERSION}

          help                - Print this message
          link                - Link your account
          on                  - Start receiving notifications
          off                 - Stop receiving notifications

          You can invoke slackerduty using /slackerduty or /sd
          ```
        MESSAGE
      end
    end
  end
end
