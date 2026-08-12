FactoryBot.define do
  factory :recruitment_part do
    association :band_recruitment
    part { :vocal }
    max_count { 1 }
  end
end
