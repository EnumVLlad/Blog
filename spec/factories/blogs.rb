FactoryBot.define do
  factory :blog do
    sequence(:title) { |n| "Test Blog #{n}" }
    body { "Test body" }
    category { "travel" }
    association :user
  end
end
