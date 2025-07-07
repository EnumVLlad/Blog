FactoryBot.define do
  factory :blog do
    sequence(:title) { |n| "Test Blog #{n}" }
    body { "Test body" }
    category { "travel" } # valid default category
    association :user
  end
end
