# frozen_string_literal: true

RSpec.describe Api::Controllers::Webhooks::PagerDuty, type: :action do
  let(:action) { described_class.new }

  context 'when params are not valid' do
    let(:params) { {} }
    let(:response) { action.call(params) }
    let(:parameter_errors) do
      Api::Controllers::Webhooks::PagerDutyWebhookParams.new(params).errors
    end

    it 'returns 422 UNPROCESSABLE ENTITY' do
      expect(response[0]).to eq(422)
    end

    it 'returns errors' do
      expect(response[2]).to eq([parameter_errors.to_json])
    end
  end

  context 'when params are valid' do
    let(:token) { 'token' }
    let(:message_one) do
      {
        'event' => 'incident.trigger',
        'incident' => {
          'id' => 'id_1',
          'incident_number' => 1,
          'title' => 'Server is on fire',
          'status' => 'triggered',
          'summary' => '[#1] Server is on fire',
          'type' => 'incident',
          'created_at' => DateTime.parse('2001-01-01T00:00:00Z'),
          'service' => { 'summary' => 'Service' },
          'acknowledgements' => [
            {
              'acknowledger' => {
                'type' => 'user',
                'id' => 'user_1',
                'summary' => 'Biss Boss'
              }
            }
          ]
        },
        'log_entries' => [
          {
            'type' => 'log_entry_type_1',
            'agent' => {
              'type' => 'user',
              'id' => 'agent_1',
              'summary' => 'Agent Summary'
            }
          }
        ]
      }
    end

    let(:message_two) do
      {
        'event' => 'incident.trigger',
        'incident' => {
          'id' => 'incident_2',
          'incident_number' => 2,
          'title' => 'Server is on fire',
          'status' => 'triggered',
          'summary' => '[#2] Server is on fire',
          'type' => 'incident',
          'created_at' => DateTime.parse('2001-01-01T00:00:00Z'),
          'service' => { 'summary' => 'Service' },
          'acknowledgements' => [
            {
              'acknowledger' => {
                'type' => 'user',
                'id' => 'user_2',
                'summary' => 'Biss Boss'
              }
            }
          ]
        },
        'log_entries' => [
          {
            'type' => 'log_entry_type_2',
            'agent' => {
              'type' => 'user',
              'id' => 'agent_2',
              'summary' => 'Agent Summary'
            }
          }
        ]
      }
    end

    let(:params) do
      {
        'pager_duty_token' => token,
        'messages' => [message_one, message_two]
      }
    end

    before do
      allow(Slackerduty::Workers::ProcessPagerDutyEvent).to(
        receive(:perform_async)
      )
    end

    it 'return 202 ACCEPTED' do
      response = action.call(params)
      expect(response[0]).to eq 202
    end

    it 'returns json' do
      response = action.call(params)
      expect(response[2]).to eq [{ status: :accepted }.to_json]
    end

    it 'enqueues a job to process each message' do
      action.call(params)

      expect(Slackerduty::Workers::ProcessPagerDutyEvent).to(
        have_received(:perform_async).twice
      )
    end

    it 'enqueues a job for the first message' do
      action.call(params)

      expect(Slackerduty::Workers::ProcessPagerDutyEvent).to have_received(:perform_async).with(
        message: message_one.deep_symbolize_keys,
        token: token
      )
    end

    it 'enqueues a job for the second message' do
      action.call(params)

      expect(Slackerduty::Workers::ProcessPagerDutyEvent).to have_received(:perform_async).with(
        message: message_two.deep_symbolize_keys,
        token: token
      )
    end
  end
end
