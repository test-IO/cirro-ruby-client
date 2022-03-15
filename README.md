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
