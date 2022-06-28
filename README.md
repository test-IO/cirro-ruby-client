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

## Usage

### Get user info

```ruby
client.User.find(1)
```

### Create a gig

```ruby
client.Gig.create(
  title: "Favourite programming language?",
  description: "Description of gig ...",
  url: "http://heathcote.co/zina.gibson"
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
```

### Get list of gig invitations

By default the response is paginated with 10 per page. The `has_more` attribute indicates whether there're more records to be fetched or not.
You can move from page to page using `after` or `before`.

```ruby
# return all with max limit
client.GigInvitation.all(limit: 100)

# return paginated after gig invitation ID 100
client.GigInvitation.all(limit: 100, after: 100)

# return paginated before gig invitation ID 100
client.GigInvitation.all(limit: 100, before: 100)

# filter by user with ID 1 and gig with ID 1
client.GigInvitation.all(user: 1, gig: 1)

# filter by status
client.GigInvitation.all(status: ['pending', 'accepted'])
client.GigInvitation.all(status: 'accepted')
```

### Create a notification broadcast

```ruby
client.NotificationBroadcast.create(
  payload: {
    foo: 'bar',
    key: 'value'
  },
  recipients: {
    user_ids: [1, 2, 3]
  }
)
```
