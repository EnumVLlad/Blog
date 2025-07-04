FactoryBot.define do
  factory :blog do
    sequence(:title) { |n| "Test Blog #{n}" }
    body { "Test body" }
    association :user
  end
end
