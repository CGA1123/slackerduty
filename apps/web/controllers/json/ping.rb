# frozen_string_literal: true

module Web
  module Controllers
    module Json
      class Ping
        include Web::Action

        before :authenticate_user!

        def call(*)
          self.body = { message: 'pong' }.to_json
          headers.merge!('Content-Type' => 'application/json')
        end
      end
    end
  end
end
