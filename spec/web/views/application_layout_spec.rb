# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Web::Views::ApplicationLayout, type: :view do
  let(:user) { instance_double('user', email: 'email@email.co.uk') }
  let(:exposures) { Hash[current_user: user, params: {}, format: :html, flash: {}] }
  let(:layout) { described_class.new(exposures, 'contents') }
  let(:rendered) { layout.render }

  it 'contains application name' do
    expect(rendered).to include('slackerduty')
  end
end
