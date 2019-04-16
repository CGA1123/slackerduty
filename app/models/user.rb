# frozen_string_literal: true

module Models
  class User < ActiveRecord::Base
    has_many :subscriptions, class_name: 'Subscription'
    has_many :messages, class_name: 'Message'
  end
end
