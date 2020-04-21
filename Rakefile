# frozen_string_literal: true

require 'rake'
require 'hanami/rake_tasks'

namespace :assets do
  task :precompile do
    `yarn run webpack`
    `cp apps/web/assets/favicon.ico public/assets/favicon.ico`
  end
end

task cleanup_old_incidents: :environment do
  connection = Hanami::Repository.configuration.connection

  messages_sql = <<~SQL
    DELETE
    FROM messages
    WHERE incident_id IN (
      SELECT id
      FROM incidents
      WHERE status = 'resolved'
    )
  SQL

  incidents_sql = <<~SQL
    DELETE
    FROM incidents
    WHERE status = 'resolved'
  SQL

  connection.transaction do |t|
    t.execute(messages_sql)
    t.execute(incidents_sql)
  end
end
