FactoryBot.define do
  factory :profile do
    association :user
    nickname { Faker::Lorem.characters(number: 5) }
    gender { :male }
    birth_date { Date.new(1996, 6, 1) }
    part { :vocal }
  end
end
