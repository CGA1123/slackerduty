web: bundle exec rackup -p $PORT
release: bundle exec hanami db migrate
worker: bundle exec sidekiq --require ./config/boot.rb
