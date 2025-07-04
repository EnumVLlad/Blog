class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :authorize_blog!, only: [:edit, :update, :destroy]

  def index
    @blogs = Blog.includes(:user)
    if params[:q].present?
      q = "%#{params[:q].strip}%"
      @blogs = @blogs.where('title ILIKE ? OR body ILIKE ?', q, q)
    end
    if params[:category].present?
      @blogs = @blogs.where(category: params[:category])
    end

    case params[:sort]
    when 'oldest'
      @blogs = @blogs.order(created_at: :asc)
    when 'likes_desc'
      @blogs = @blogs.left_joins(:likes).group('blogs.id').order('COUNT(likes.id) DESC')
    when 'likes_asc'
      @blogs = @blogs.left_joins(:likes).group('blogs.id').order('COUNT(likes.id) ASC')
    when 'views_desc'
      @blogs = @blogs.order(views: :desc)
    when 'views_asc'
      @blogs = @blogs.order(views: :asc)
    when 'title_asc'
      @blogs = @blogs.order(title: :asc)
    when 'title_desc'
      @blogs = @blogs.order(title: :desc)
    else
      @blogs = @blogs.order(created_at: :desc)
    end
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

  def show
    # @blog уже установлен через set_blog
    @blog.update_column(:views, @blog.views + 1)
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
      params.require(:blog).permit(:title, :body, :category)
    end
end
