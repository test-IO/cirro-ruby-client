# CirroIOV2::Client

This gem provides access to the [Cirro REST API v2](https://cirroapiv2.docs.apiary.io).

[![CircleCI](https://circleci.com/gh/test-IO/cirro-ruby-client/tree/master.svg?style=svg&circle-token=a77e4eac5646768d681283763d2a29a55a221d7c)](https://circleci.com/gh/test-IO/cirro-ruby-client/tree/master)

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

### Create or update a worker document for a user
Will automatically create a worker account if not existing
```ruby
user = client.User.worker(1, document: { foo: :bar })
# => User object

user.worker.document
# => { foo: :bar }
```

### Get notification preference of a user

```ruby
client.User.notification_preference(1)
# => NotificationPreference object
```
### Create or Update notification preferences for a user

```ruby
client.User.notification_preferences(1, {
  locale: 'de',
  topics: [
    { id: '1', preferences: { email: 'immediately' } },
    { id: '2', preferences: { email: 'digest_daily' } }
  ]
})
```

### Seed user (staging/dev only)

```ruby
# With params (all of them optional)
# Password must include at least: 2 letters, 2 digits, 2 special characters
# Email must be unique
client.User.create(
  first_name: 'Human',
  last_name: 'Being',
  email: 'iamhuman@test.io',
  time_zone: 'Berlin',
  country_code: 'DE',
  birthday: '1975-11-22',
  password: '@123456abc@'
)
# => User object

# Without params (nimbus-style, all params are seeded by Cirro)
client.User.create
# => User object
```

## Gig
### Find a gig

```ruby
client.Gig.find(ID)
# => Gig object
```
### Create a gig

```ruby
client.Gig.create(
  title: "Favourite programming language?",
  description: "Description of gig ...",
  url: "http://heathcote.co/zina.gibson",
  start_at: 1652285764,
  end_at: 1653412329,
  seats_min: 2,
  seats_max: 2,
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

### Update a gig
When your gig is already started, you can not update start_at anymore
```ruby
gig_id = 1
client.Gig.update(gig_id,
  title: "Favourite programming language?",
  description: "Description of gig ...",
  url: "http://heathcote.co/zina.gibson",
  start_at: 1652285764,
  end_at: 1653412329,
  seats_min: 2,
  seats_max: 2,
  invitation_mode: "auto",
  filter_query: {
    status: "active",
    segment: "my_favorite_testers"
  },
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

### Archive a gig

```ruby
gig_id = 1

# archive now
client.Gig.archive(gig_id)

# archive later
client.Gig.archive(gig_id, archive_at: 1.day.from_now)
```

### Delete a gig

```ruby
gig_id = 1

client.Gig.delete(gig_id)
```

### Manually invite user to a gig

##### Invite single user

```ruby
gig_id = 1
app_user_id = 1

client.Gig.invite(gig_id, { user_id: app_user_id })
# => GigInvitation object
```

##### Invite multiple users and overwrite no_reward

```ruby
gig_id = 1
users = [{ id: 1, no_reward: true }, { id: 2, no_reward: true }]

client.Gig.invite(gig_id, { users: users })
# => GigInvitationList object
```

### GigTask
#### Add a new gig task to gig

```ruby
gig_id = 1

client.Gig.tasks(gig_id, { title: "Critical Bug", base_price: 100 })
# => GigTask object
```

#### Update a gig task

```ruby
gig_id = 1
gig_task_id = 1

client.Gig.update_task(gig_id, gig_task_id, { base_price: 100 })
# => GigTask object
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

# overwrite no_reward
client.GigInvitation.accept(1, no_reward: true)

```

### Reject a gig invitation

```ruby
client.GigInvitation.reject(1)
```

### Expire a gig invitation

```ruby
client.GigInvitation.expire(1)
```

### Reset an accepted or expired gig invitation

```ruby
client.GigInvitation.reset(1)

# prevent reset notification
client.GigInvitation.reset(1, silent: true)
```

## GigTimeActivity
### List all gig time activities

```ruby
list = client.GigTimeActivity.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of GigTimeActivity objects

# filters
client.GigTimeActivity.list(gig_id: 1, user_id: 1)

# pagination
client.GigTimeActivity.list(limit: 100, after: 100)
```

### Create a gig time activity
You can't create gig time activity if the given user is not in your space or for the given user the gig invitation is set to no_reward

```ruby
client.GigTimeActivity.create(
  gig_id: 1,
  user_id: 1,
  date: "2023-04-10",
  description: "Time Report for Space XYZ",
  duration_in_ms: 1.hour.in_seconds * 1000 # make sure not to report > 8h per day
)
```

## GigResult
### List all gig results

```ruby
list = client.GigResult.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of GigResult objects

# filters
client.GigResult.list(gig_id: 1, user_id: 1)

# pagination
client.GigResult.list(limit: 100, after: 100)
```

### Create a gig result
You can't create gig result if the given user is not in your space or for the given user the gig invitation is set to no_reward

```ruby
client.GigResult.create(
  gig_task_id: 1,
  user_id: 1,
  title: "Work for task1",
  escription: "Good work for task1",
  quantity: 2,
  multiplier: 1.2,
  delivery_date: "2023-04-10",
  cost_center_key: "EPMTIO"
)
```

## BonusPayout
### List all payouts

```ruby
list = client.Payout.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of Payout objects

# filters
client.Payout.list(reference_id: 1, reference_type: 'Gig', user_id: 1)

# pagination
client.Payout.list(limit: 100, after: 100)
```

### Create a bonus payout

```ruby
client.Payout.create(
  user_id: 1,
  title: "Bonus Payment",
  description: "Good work!",
  amount: 1000,
  billing_date: "2023-04-10",
  cost_center_key: "EPMTIO"
)
```

### Delete a bonus payout
Only allowed for unbilled ones

```ruby
client.Payout.delete(1)
```

# Notifications
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
### List all notification layouts

```ruby
list = client.NotificationLayout.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationLayout objects

client.NotificationLayout.list(limit: 100, after: 100) # pagination
```

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

## Notification Topic
### List all notification topics

```ruby
list = client.NotificationTopic.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationTopic objects

# filter by layout_id
client.NotificationTopic.list(notification_layout_id: 1)

# pagination
client.NotificationTopic.list(limit: 10, after: 10)
```

### Create a notification topic

```ruby
client.NotificationTopic.create(
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

### Find a notification topic

```ruby
client.NotificationTopic.find(1)
# => NotificationTopic object
```

### Update a notification topic

```ruby
client.NotificationTopic.update(1, { name: "NewTopicName", preferences: { email: "daily" } })
# => NotificationTopic object
```

### Delete a notification topic

```ruby
topic = client.NotificationTopic.delete(1)
# => NotificationTopicDelete object

topic.deleted
# => true
```

## Notification (Topic) Template
### List all

```ruby
list = client.NotificationTemplate.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationTemplate objects

# filter by topic id
client.NotificationTemplate.list(notification_topic_id: 1)

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
client.NotificationTemplate.delete(1)
```

## Notifcation Topic Preference
### List all

```ruby
list = client.NotificationTopicPreference.list
# => ListObject

list.has_more?
# => true

list.data
# => Array of NotificationTopicPreference objects

# filter by topic id
client.NotificationTopicPreference.list(notification_topic_id: 1)

# filter by user id
client.NotificationTopicPreference.list(user_id: 1)

# pagination
client.NotificationTopicPreference.list(limit: 10, after: 10)
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
  notification_topic_id: 1
)
```

# CirroIO::Client (DEPRECATED)

## Configuration

  You need to create an initializer file in config/initializers.

  ```ruby
  CirroIO::Client.configure do |c|
    c.app_id 'WULnc6Y0rlaTBCSiHAb0kGWKFuIxPWBXJysyZeG3Rtw'
    c.private_key_path './storage/cirro.pem'
    c.site 'https://api.staging.cirro.io'
  end
  ```



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

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then wait for circle CI to complete, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).