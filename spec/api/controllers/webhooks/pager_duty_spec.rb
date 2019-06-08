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
          'id' => SecureRandom.hex
        },
        'log_entries' => [
          {
            'type' => SecureRandom.hex,
            'agent' => {
              'id' => SecureRandom.hex,
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
          'id' => SecureRandom.hex
        },
        'log_entries' => [
          {
            'type' => SecureRandom.hex,
            'agent' => {
              'id' => SecureRandom.hex,
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
