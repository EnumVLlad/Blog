class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog

  def create
    @comment = @blog.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to blogs_path(anchor: "blog-#{@blog.id}"), notice: 'Коментар додано.'
    else
      redirect_to blogs_path(anchor: "blog-#{@blog.id}"), alert: 'Помилка: коментар не збережено.'
    end
  end

  def destroy
    @comment = @blog.comments.find(params[:id])
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      redirect_to blogs_path(anchor: "blog-#{@blog.id}"), notice: 'Коментар видалено.'
    else
      redirect_to blogs_path(anchor: "blog-#{@blog.id}"), alert: 'Ви не маєте прав для видалення цього коментаря.'
    end
  end

  private
  def set_blog
    @blog = Blog.find(params[:blog_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
