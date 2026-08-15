FactoryBot.define do
  factory :recruitment_application do
    association :band_recruitment
    application_comment { Faker::Lorem.characters(number: 10) }
  end
end
