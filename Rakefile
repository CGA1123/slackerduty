# frozen_string_literal: true

require 'rake'
require 'hanami/rake_tasks'

namespace :assets do
  task :precompile do
    `yarn run webpack`
    `cp apps/web/assets/favicon.ico public/assets/favicon.ico`
  end
end
