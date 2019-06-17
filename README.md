# PagerDuty → Slack :pager:

A Slack App that allows you to manage PagerDuty incidents from Slack!

![Honeycomb - Ackd](https://user-images.githubusercontent.com/7707413/58975055-ed37c500-87bb-11e9-851e-396ad1a506e8.png)
![Bugsnag - Resolved](https://user-images.githubusercontent.com/7707413/58974944-a4800c00-87bb-11e9-9593-b4db217af959.png)

## Installation

### Running the web server

Assumes you have your database and redis server running.

- `gem install bundler`
- `bundle`
- `bundle exec rake db:setup`
- `gem install foreman`
- `foreman start`

You can access the sidekiq web panel at `/sidekiq`.

## Usage

See `/slackerduty help` in Slack!

## Contributing

1. Fork it (<https://github.com/CGA1123/slackerduty/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
