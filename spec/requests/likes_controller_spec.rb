require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:blog) { Blog.create!(title: "Test Blog", body: "Body", user: User.create!(email: "test2@test.com", password: "password", role: "user")) }

  describe "POST /blogs/:blog_id/likes" do
    it "returns http redirect (302)" do
      post blog_likes_path(blog)
      expect(response).to have_http_status(302)
    end
  end
end
