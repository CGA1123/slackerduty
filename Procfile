web: bundle exec rackup -p $PORT
worker: bundle exec sidekiq -q slackerduty -c 5 --require ./app.rb
