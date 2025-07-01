class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog

  def create
    like = @blog.likes.find_or_initialize_by(user: current_user)
    like.value = params[:value].to_i
    if [-1,1].include?(like.value)
      like.save
    end
    redirect_to blogs_path(anchor: "blog-#{@blog.id}")
  end

  private
  def set_blog
    @blog = Blog.find(params[:blog_id])
  end
end
