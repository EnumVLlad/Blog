require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:blog) { create(:blog) }

  describe "POST /blogs/:blog_id/comments" do
    it "returns http redirect (302)" do
      post blog_comments_path(blog), params: { comment: { body: "Test comment" } }
      expect(response).to have_http_status(302)
    end
  end

  describe "DELETE /blogs/:blog_id/comments/:id" do
    let!(:comment) { create(:comment, blog: blog, user: blog.user) }
    it "returns http redirect (302)" do
      delete blog_comment_path(blog, comment)
      expect(response).to have_http_status(302)
    end
  end
end
