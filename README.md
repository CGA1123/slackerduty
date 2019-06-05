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

| Variable | Description |
| --- | --- |
| `BUGSNAG_API_TOKEN` | Bugnsag API Token (only required if you want to use Bugnsag Integration) |
| `PAGERDUTY_TOKEN` | PagerDuty REST API Token |
| `PAGERDUTY_PASS` | PagerDuty Webhook HTTP Basic Auth Password |
| `PAGERDUTY_USER` | PagerDuty Webhook HTTP Basic Auth Username |
| `SIDEKIQ_PASSWORD` | Password to access Sidkiq Web UI |
| `SIDEKIQ_USERNAME` | Username to access Sidekiq Web UI |
| `SLACK_BOT_OAUTH_TOKEN` | The slack bot OAuth token used to post and update messages, and fetch users |
| `SLACK_SIGNING_SECRET` | The slack signing secret used to verify actions and commands |
| `DATABASE_URL` | The url to your postgres instance |
| `REDIS_URL` | The url to your redis instance |


### Setting up your Slack App

You will need to [create a new app](https://api.slack.com/apps) on slack and add your workspace as
the development workspace.

- Under `Interactive Components` you should set the `Request URL` to `https://<domain>/slack/action`

- Under `Slack Commands` you should create a command and set it's `Request URL` to `https://<domain>/slack/command`

- Under `OAuth & Permissions` request to following permissions: `chat:write:bot`, `users:read`, `users:read.email`, `users.profile:read`

- Under `Bot Users` create a bot user.

### Setting up PagerDuty Webhook(s)

- Go to `/extensions` once logged in the [PagerDuty Web UI](https://app.pagerduty.com).
- Create a `Generic V2 Webhook`
- Set the name to something useful (`slackerduty`?)
- Select the `Service` you wish to send to associated incidents to `slackerduty`
- Set the url as `https://PAGERDUTY_USER:PAGERDUTY_PASS@<domain>/pager_duty`
- Click on the :gear: to copy across to another service!

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
