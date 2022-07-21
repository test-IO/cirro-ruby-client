# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: OpenStruct do
    id { SecureRandom.uuid }
    object { 'gig_invitation' }
    Status { 'pending' }
    gig_id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
  end
end
