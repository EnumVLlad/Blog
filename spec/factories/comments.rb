FactoryBot.define do
  factory :comment do
    body { "Test comment" }
    association :user
    association :blog
  end
end
