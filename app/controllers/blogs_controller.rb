class BlogsController < ApplicationController
  before_action :set_blog, only: [:edit, :update, :destroy]
  before_action :authorize_blog!, only: [:edit, :update, :destroy]

  def index
    @blogs = Blog.includes(:user).order(created_at: :desc)
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user = current_user if defined?(current_user)
    if @blog.save
      flash[:notice] = 'Блог успішно створено!'
      redirect_to blogs_path
    else
      flash.now[:alert] = 'Виправте помилки у формі.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @blog.update(blog_params)
      flash[:notice] = 'Блог оновлено!'
      redirect_to blogs_path
    else
      flash.now[:alert] = 'Виправте помилки у формі.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy
    flash[:notice] = 'Блог видалено.'
    redirect_to blogs_path
  end

  private
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def authorize_blog!
      unless @blog.user == current_user
        flash[:alert] = 'Ви не можете змінювати або видаляти цей блог.'
        redirect_to blogs_path
      end
    end

    def blog_params
      params.require(:blog).permit(:title, :body)
    end
end
