# frozen_string_literal{ true

FactoryBot.define do
  factory :gig, class: OpenStruct do
    id { SecureRandom.uuid }
    object { 'gig' }
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    url { 'http://heathcote.co/zina.gibson' }
    start_at { Faker::Number.number(10) }
    end_at { Faker::Number.number(10) }
    total_seats { rand(1..10) }
    invitation_mode { 'auto' }
    filter_query do
      { status: 'active',
        segment: 'my_favorite_testers' }
    end
    tasks do
      {
        object: 'list',
        data: [{
          id: SecureRandom.uuid,
          object: 'gig_task',
          title: Faker::Lorem.word,
          base_price: 300,
        }],
      }
    end
    notification_payload do
      {
        project_title: Faker::Lorem.word,
        task_title: Faker::Lorem.word,
        task_type: 'Review',
      }
    end
    epam_options do
      {
        extra_mile: true,
      }
    end
  end
end
