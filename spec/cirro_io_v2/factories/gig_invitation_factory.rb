# frozen_string_literal: true

FactoryBot.define do
  factory :gig_invitation, class: OpenStruct do
    id { SecureRandom.uuid }
    object { 'gig_invitation' }
    status { 'pending' }
    gig_id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
  end

  factory :gig_invitations_list, class: OpenStruct do
    object { 'list' }
    url { '/gig_invitations' }
    has_more { false }
    data { FactoryBot.build_list(:gig_invitation, 2) }
  end
end
