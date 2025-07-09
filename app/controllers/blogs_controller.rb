class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :authorize_blog!, only: [:edit, :update, :destroy]

  def index
    @blogs = BlogsQuery.new(Blog.all, params).call
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

  before_action :authenticate_user!, only: [:pay, :payment]

  def show
    if @blog.paid?
      if user_signed_in? && (current_user == @blog.user || current_user.admin? || current_user.accessible_blogs.exists?(@blog.id))
      else
        @access_denied = true
        return
      end
    end
    @blog.update_column(:views, @blog.views + 1)
  end

  def payment
    @blog = Blog.find(params[:id])
  end

  def pay
    @blog = Blog.find(params[:id])
    unless current_user.accessible_blogs.exists?(@blog.id) || current_user == @blog.user || current_user.admin?
      current_user.blog_accesses.create!(blog: @blog)
    end
    redirect_to blog_path(@blog), notice: 'Доступ до поста оплачено!'
  end

  private
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def authorize_blog!
      unless @blog.user == current_user || current_user.admin?
        redirect_to blogs_path, alert: 'Ви не маєте прав для цієї дії.'
      end
    end

    def blog_params
      params.require(:blog).permit(:title, :body, :category, :paid)
    end
end
