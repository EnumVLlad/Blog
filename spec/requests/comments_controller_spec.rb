require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:blog) { Blog.create!(title: "Test Blog", body: "Body", user: User.create!(email: "test@test.com", password: "password", role: "user")) }

  describe "POST /blogs/:blog_id/comments" do
    it "returns http redirect (302)" do
      post blog_comments_path(blog), params: { comment: { body: "Test comment" } }
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /blogs/:blog_id/comments/:id" do
    let!(:comment) { blog.comments.create!(body: "Test comment", user: blog.user) }
    it "returns http redirect (302)" do
      delete blog_comment_path(blog, comment)
      expect(response).to have_http_status(302)
    end
  end
end
