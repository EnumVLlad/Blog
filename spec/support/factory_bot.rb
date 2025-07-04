RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.create(:user, email: 'testuser@example.com') unless User.exists?(email: 'testuser@example.com')
  end
end

RSpec.shared_context 'with global user', shared_context: :metadata do
  let(:user) { User.find_by(email: 'testuser@example.com') }
end

RSpec.configure do |config|
  config.include_context 'with global user', include_shared: true
end
