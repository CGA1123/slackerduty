# frozen_string_literal: true

require 'features_helper'

RSpec.describe 'Visting /' do
  it 'is successful' do
    visit '/'

    expect(page).to have_content('PagerDuty → Slack 📟')
  end
end
