class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog

  def create
    @comment = @blog.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      if params[:redirect_to_show]
        redirect_to blog_path(@blog), notice: 'Коментар додано.'
      else
        redirect_to blogs_path(anchor: "blog-#{@blog.id}"), notice: 'Коментар додано.'
      end
    else
      if params[:redirect_to_show]
        redirect_to blog_path(@blog), alert: 'Помилка: коментар не збережено.'
      else
        redirect_to blogs_path(anchor: "blog-#{@blog.id}"), alert: 'Помилка: коментар не збережено.'
      end
    end
  end

  def destroy
    @comment = @blog.comments.find(params[:id])
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      if params[:redirect_to_show]
        redirect_to blog_path(@blog), notice: 'Коментар видалено.'
      else
        redirect_to blogs_path(anchor: "blog-#{@blog.id}"), notice: 'Коментар видалено.'
      end
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
