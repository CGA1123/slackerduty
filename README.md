# PagerDuty → Slack :pager:

A Slack App that allows you to manage PagerDuty incidents from Slack!

## Installation

Manual installation and hosting is required at the moment to add this to your workspace.

### Environment Variables

The following environment variables should be set:

    BUGSNAG_API_TOKEN=
    PAGERDUTY_TOKEN=
    PAGERDUTY_PASS=
    PAGERDUTY_USER=
    SIDEKIQ_PASSWORD=
    SIDEKIQ_USERNAME=
    SLACK_BOT_OAUTH_TOKEN=
    SLACK_SIGNING_SECRET=
    DATABASE_URL=
    REDIS_URL=

`BUGSNAG_API_TOKEN` is optional and only required if you use Bugsnag.


### Setting up your Slack App

You will need to [create a new app](https://api.slack.com/apps) on slack and add your workspace as
the development workspace.

- Under `Interactive Components` you should set the `Request URL` to `https://<domain>/slack/action`

- Under `Slack Commands` you should create a command and set it's `Request URL` to `https://<domain>/slack/command`

- Under `OAuth & Permissions` request to following permissions: `chat:write:bot`, `users:read`, `users:read.email`, `users.profile:read`

- Under `Bot Users` create a bot user.

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
