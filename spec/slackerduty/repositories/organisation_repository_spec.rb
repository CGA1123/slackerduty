# frozen_string_literal: true

RSpec.describe OrganisationRepository, type: :repository do
  let(:instance) { described_class.new }

  describe '#from_pager_duty_token' do
    subject { instance.from_pager_duty_token(token) }

    let(:token) { 'beep' }

    context 'when there is a matching organisation' do
      let!(:organisation) { instance.create(params) }
      let(:params) do
        {
          name: 'beep',
          pager_duty_token: token,
          slack_id: 'slack_id',
          slack_bot_id: 'slack_bot_id',
          slack_bot_token: 'slack_bot_token'
        }
      end

      it { is_expected.to eq(organisation) }
    end

    context 'when there is no matching organisation' do
      it { is_expected.to eq(nil) }
    end
  end
end
