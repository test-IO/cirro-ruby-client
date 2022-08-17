# CirroIO::Client

This gem provides access to the [Cirro REST API](https://staging.cirro.io/api-docs/v1#cirro-api-documentation).

[![CircleCI](https://circleci.com/gh/test-IO/cirro-ruby-client/tree/master.svg?style=svg)](https://circleci.com/gh/test-IO/cirro-ruby-client/tree/master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cirro-ruby-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cirro-ruby-client


## Configuration

  You need to create an initializer file in config/initializers.

  ```ruby
  CirroIO::Client.configure do |c|
    c.app_id 'WULnc6Y0rlaTBCSiHAb0kGWKFuIxPWBXJysyZeG3Rtw'
    c.private_key_path './storage/cirro.pem'
    c.site 'https://api.staging.cirro.io'
  end
  ```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Usage

#### Bulk create gig invitations

```ruby
gig = CirroIO::Client::Gig.load(id: 1)
filter = CirroIO::Client::WorkerFilter.new(filter_query: '{ "app_worker_id": { "$in": [1,2,3] } }')
invitation = CirroIO::Client::GigInvitation.new(gig: gig)

invitation.bulk_create_with(filter, auto_accept: true) # by default auto_accept is false
```

#### Creating Payouts for workers

```ruby
app_worker = CirroIO::Client::AppWorker.load(id: 1234)

CirroIO::Client::Payout.create(
  app_worker: app_worker,
  amount: 100, # € 1.00
  title: "Bonus for something",
  description: "Description of the bonus.",
  cost_center_key: "PROJECT-CODE",
  billing_date: DateTime.now
)
```

# CirroIOV2::Client

## Configuration

  ```ruby
  # with key path
  client = CirroIOV2::Client.new(private_key_path: "./storage/cirro_key.pem", client_id: "WULnc6Y0rlaTBCSiHAb0kGWKFuIxPWBXJysyZeG3Rtw", site: "https://api.staging.cirro.io")

  # with key string
  client = CirroIOV2::Client.new(private_key: Rails.application.credentials.cirro_private_key, client_id: "WULnc6Y0rlaTBCSiHAb0kGWKFuIxPWBXJysyZeG3Rtw", site: "https://api.staging.cirro.io")
  ```

# Usage

## User
### Get user info

```ruby
user = client.User.find(1)
# => User object

user.first_name
# => 'Grazyna'

user.worker
# => { billable: false, document: {...} }
```

### Get notification preferences for a user

```ruby
preference = client.User.get_notification_preference(1)
# => NotificationPreference object

preference.id
# => '1'

preference.locale
# => 'de'

preference.channels
# => Array of NotificationChannelPreference objects
```

### Update notification preferences for a user

```ruby
client.User.update_notification_preference({
  locale: 'de',
  channels: [
    { id: '1', preferences: { email: 'immediately' } },
    { id: '2', preferences: { email: 'digest_daily' } }
  ]
})
```

## Gig
### Create a gig

```ruby
client.Gig.create(
  title: "Favourite programming language?",
  description: "Description of gig ...",
  url: "http://heathcote.co/zina.gibson",
  start_at: 1652285764,
  end_at: 1653412329,
  total_seats: 2,
  invitation_mode: "auto",
  filter_query: {
  status: "active",
  segment: "my_favorite_testers"
  },
  tasks: [
    { title: "Ah, Wilderness!", base_price: 300 }
  ],
  notification_payload: {
    project_title: "Corporate Tax",
    task_title: "Add dataset",
    task_type: "Review"
  },
  epam_options: {
    extra_mile: true
  }
)
# => Gig object
```

## GigInvitation
### Get list of gig invitations

By default the response is paginated with 10 per page. The `has_more` attribute indicates whether there're more records to be fetched or not.
You can move from page to page using `after` or `before`.

```ruby
# return all with max limit
client.GigInvitation.list(limit: 100)

# return paginated after gig invitation ID 100
client.GigInvitation.list(limit: 100, after: 100)

# return paginated before gig invitation ID 100
client.GigInvitation.list(limit: 100, before: 100)

# filter by user with ID 1 and gig with ID 1
client.GigInvitation.list(user_id: 1, gig_id: 1)

# filter by status
client.GigInvitation.list(status: ['pending', 'accepted'])
client.GigInvitation.list(status: 'accepted')

list = client.GigInvitation.list(limit: 100)
# => ListObject

list.has_more?
# => true

list.data
# => Array of GigInvitation objects
```

### Accept a gig invitation

```ruby
client.GigInvitation.accept(1)
```

## Notification Locale
### Create a notification locale

```ruby
locale = client.NotificationLocale.create(locale: 'de')
# => NotificationLocale object

locale.locale
# => 'de'

locale.configurations
# => Array of NotificationConfiguration objects
```

### List all notification locales

```ruby
list = client.NotificationLocale.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationLocale objects

client.NotificationLocale.list(default: true) # filter by default
```

## Notification Configuration
### List all notification configurations

```ruby
list = client.NotificationConfiguration.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationConfiguration objects

client.NotificationConfiguration.list(locale: 'de') # filter by locale

client.NotificationConfiguration.list(limit: 100, after: 100) # pagination
```

## Notification Layout
### Create a notification layout

```ruby
client.NotificationLayout.create(
  name: 'custom_layout',
  templates: [
    { notification_configuration_id: '1', body: '<p>hello {{recipient}}</p>' },
    { notification_configuration_id: '2', body: '<p>hallo {{recipient}}</p>' }
  ]
)
```

### Update a notification layout

```ruby
client.NotificationLayout.update('1', name: 'custom_layout')
```

### Create a new template

```ruby
client.NotificationLayout.create_template(
  '1',
  { notification_configuration_id: '1', body: '<p>hello {{recipient}}</p>' }
)
# => NotificationLayoutTemplate object
```

## Notification Layout Template
### Update a notification layout template

```ruby
client.NotificationLayoutTemplate.update(
  '1',
  { notification_configuration_id: '1', body: '<p>hello {{recipient}}</p>' }
)
```
### Delete a notification layout template

```ruby
client.NotificationLayoutTemplate.delete('1')
```

## Notification Channel
### List all notification channels

```ruby
list = client.NotificationChannel
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationChannel objects

# filter by layout_id
client.NotificationChannel.list(notification_layout_id: 1)

# pagination
client.NotificationChannel.list(limit: 10, after: 10)
```

### Create a notification channel

```ruby
client.NotificationChannel.create(
  name: 'new_bug_comment',
  notification_layout_id: 1,
  preferences: {
    email: 'immediately'
  },
  templates: [
    {
      "notification_configuration_id": "1",
      "subject": "New Bug Comment",
      "body": "Hello {{recipient_first_name}}, you got {{pluralize count, 'new comment', 'new comments'}}"
    },
    {
      "notification_configuration_id": "2",
      "subject": "Neuer Kommentar",
      "body": "Hallo {{recipient_first_name}}, Du hast {{pluralize count, 'neuen Kommentar', 'neue Kommentare'}}"
    }
  ]
)
```

## Notification (Channel) Template
### List all

```ruby
list = client.NotificationTemplate
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationTemplate objects

# filter by channel id
client.NotificationTemplate.list(notification_channel_id: 1)

# filter by configuration id
client.NotificationTemplate.list(notification_configuration_id: 1)

# pagination
client.NotificationTemplate.list(limit: 10, after: 10)
```

### Update a notification template

```ruby
client.NotificationTemplate.update(
  '1',
  "subject": "New Bug Comment",
  "body": "Hello {{recipient_first_name}}, you got {{pluralize count, 'new comment', 'new comments'}}"
)
``` 

### Delete a notification template

```ruby
client.NotificationTemplate.delete('1')
``` 
## Notifcation Channel Preference
### List all

```ruby
list = client.NotificationChannelPreference.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationChannelPreference objects

# filter by channel id
client.NotificationChannelPreference.list(notification_channel_id: 1)

# filter by user id
client.NotificationChannelPreference.list(user_id: 1)

# pagination
client.NotificationChannelPreference.list(limit: 10, after: 10)
```

## Notifcation Broadcast
### Create a notifcation broadcast

```ruby
client.NotificationBroadcast.create(
  payload: {
    foo: 'bar',
    key: 'value'
  },
  recipients: {
    user_ids: [1, 2, 3]
  },
  notification_channel_id: 1
)
```
