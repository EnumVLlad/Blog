class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog

  def create
    @comment = @blog.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.js
        format.html { redirect_with_notice('Коментар додано.') }
      else
        format.js
        format.html { redirect_with_alert('Помилка: коментар не збережено.') }
      end
    end
  end

  def destroy
    @comment = @blog.comments.find(params[:id])
    respond_to do |format|
      if @comment.user == current_user || current_user.admin?
        @comment.destroy
        format.js
        format.html { redirect_with_notice('Коментар видалено.') }
      else
        format.js
        format.html { redirect_with_alert('Ви не маєте прав для видалення цього коментаря.') }
      end
    end
  end

  private

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def redirect_path
    if params[:redirect_to_show]
      blog_path(@blog)
    else
      blogs_path(anchor: "blog-#{@blog.id}")
    end
  end

  def redirect_with_notice(message)
    redirect_to redirect_path, notice: message
  end

  def redirect_with_alert(message)
    redirect_to redirect_path, alert: message
  end
end
