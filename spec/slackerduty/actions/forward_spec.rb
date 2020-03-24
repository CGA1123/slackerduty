# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Slackerduty::Actions::Forward do
  let(:user) { nil }
  let(:organisation) { double('organisation', id: 1123) }
  let(:incident) { double('incident', id: '3211') }
  let(:incident_repo) { double('incident_repo', find: incident) }
  let(:forward_repo) { ForwardRepository.new }
  let(:alert) { double('alert', as_json: nil, notification_text: nil) }
  let(:payload) do
    {
      selected_conversation: 'channel_id',
      action_id: 'forward-3211'
    }
  end

  describe 'tracking forwards' do
    before do
      allow(Slackerduty::Alert).to receive(:new).and_return(alert)
      allow(Slackerduty::Workers::SendSlackMessage).to receive(:perform_async)
      allow(forward_repo).to receive(:create)
      allow(Time).to receive(:now).and_return(Time.at(1123))
    end

    it 'creates a forward' do
      instance = described_class.new(
        incident_repository: incident_repo,
        forward_repository: forward_repo
      )

      instance.call(organisation, user, payload)

      expect(forward_repo).to have_received(:create).with(
        incident_id: '3211',
        organisation_id: 1123,
        channel_id: 'channel_id',
        timestamp: Time.at(1123)
      )
    end
  end
end
