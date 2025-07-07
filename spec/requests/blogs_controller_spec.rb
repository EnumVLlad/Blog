require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  before do
    allow_any_instance_of(Blog).to receive(:notify_telegram_channel)
  end
  let!(:user) { create(:user) }

  describe "GET /blogs" do
    it "returns http success" do
      get blogs_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /blogs/new" do
    it "returns http success" do
      get new_blog_path
      expect([200, 302]).to include(response.status)
    end
  end
end
