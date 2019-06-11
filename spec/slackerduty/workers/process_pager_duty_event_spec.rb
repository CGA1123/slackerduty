# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Slackerduty::Workers::ProcessPagerDutyEvent do
  let(:instance) { described_class.new }
  let(:operation) { instance_double('operation', call: nil) }
  let(:params) do
    {
      'token' => 'token',
      'message' => {
        'event' => { 'key' => 'event' },
        'log_entries' => [{ 'key' => 'log_entries' }]
      }
    }
  end

  describe '#perform' do
    before do
      allow(Slackerduty::Operations::ProcessPagerDutyEvent).to(
        receive(:new).and_return(operation)
      )
    end

    let(:expected_params) do
      {
        token: 'token',
        event: { key: 'event' },
        log_entries: [{ key: 'log_entries' }]
      }
    end

    it 'calls process operation' do
      instance.perform(params)

      expect(operation).to have_received(:call).with(expected_params)
    end
  end
end
