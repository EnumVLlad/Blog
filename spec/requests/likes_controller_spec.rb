require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:blog) { create(:blog) }
  let(:user) { create(:user) }

  context "when user is signed in" do
    before do
      sign_in user
    end

    it "increases the number of likes" do
      expect {
        post blog_likes_path(blog), params: { value: 1 }
      }.to change { blog.likes.count }.by(1)
    end

    it "does not allow to like twice" do
      post blog_likes_path(blog), params: { value: 1 }
      expect {
        post blog_likes_path(blog), params: { value: 1 }
      }.not_to change { blog.likes.count }
    end
  end

  context "when user is not signed in" do
    it "redirects to login" do
      post blog_likes_path(blog)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
