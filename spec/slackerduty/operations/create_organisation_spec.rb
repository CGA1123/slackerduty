# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Slackerduty::Operations::CreateOrganisation do
  let(:instance) { described_class.new(repository: repository) }
  let(:organisation) { instance_double('organisation') }

  describe '#call' do
    let(:params) do
      {
        name: 'name',
        slack_id: 'slack_id',
        slack_bot_token: 'bot_token',
        slack_bot_id: 'bot_id'
      }
    end

    context 'when organisation already exists' do
      let(:repository) { instance_double('repository', from_slack_id: organisation) }

      before do
        allow(repository).to(
          receive(:from_slack_id)
          .with('slack_id')
          .and_return(organisation)
        )
      end

      it 'is successful' do
        expect(instance.call(params)).to be_successful
      end

      it 'exposes the organisation' do
        expect(instance.call(params).organisation).to eq(organisation)
      end
    end

    context 'when organisation does not exist' do
      let(:repository) { instance_double('repository', from_slack_id: nil, create: 'created') }

      it 'is successful' do
        expect(instance.call(params)).to be_successful
      end

      it 'exposes the organisation' do
        expect(instance.call(params).organisation).to eq('created')
      end

      it 'calls create' do
        instance.call(params)

        expect(repository).to have_received(:create).with(params)
      end
    end
  end
end
