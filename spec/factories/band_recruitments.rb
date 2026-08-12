FactoryBot.define do
  factory :band_recruitment do
    association :user
    title { Faker::Lorem.characters(number: 10) }
    deadline { Date.new(2026, 9, 1) }
  end
end
