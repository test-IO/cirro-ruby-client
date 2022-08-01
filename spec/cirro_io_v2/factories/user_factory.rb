# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: OpenStruct do
    id { SecureRandom.uuid }
    object { 'user' }
    first_name { Faker::Lorem.word }
    last_name { Faker::Lorem.word }
    time_zone { 'Asia/Bangkok' }
    screen_name { Faker::Lorem.word }
    country_code { 'RO' }
    epam do
      {
        id: SecureRandom.uuid,
        skills_last_synced_at: 1653955199,
        primary_skill: Faker::Lorem.sentence,
        skills: [{
          id: SecureRandom.uuid,
          name: Faker::Lorem.word,
        }],
      }
    end
    worker do
      {
        billable: false,
        document: {
          id: SecureRandom.uuid,
          foo: {
            bar: Faker::Number.number(2),
          },
        },
      }
    end
  end
end
