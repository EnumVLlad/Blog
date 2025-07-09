class BlogsQuery
  def initialize(relation = Blog.all, params = {})
    @relation = relation.includes(:user)
    @params = params
  end

  def call
    blogs = @relation
    blogs = blogs.where('title ILIKE ? OR body ILIKE ?', "%#{@params[:q].strip}%", "%#{@params[:q].strip}%") if @params[:q].present?
    blogs = blogs.where(category: @params[:category]) if @params[:category].present?

    blogs = case @params[:sort]
            when 'oldest'
              blogs.order(created_at: :asc)
            when 'likes_desc'
              blogs.left_joins(:likes).group('blogs.id').order('COUNT(likes.id) DESC')
            when 'likes_asc'
              blogs.left_joins(:likes).group('blogs.id').order('COUNT(likes.id) ASC')
            when 'views_desc'
              blogs.order(views: :desc)
            when 'views_asc'
              blogs.order(views: :asc)
            when 'title_asc'
              blogs.order(title: :asc)
            when 'title_desc'
              blogs.order(title: :desc)
            else
              blogs.order(created_at: :desc)
            end

    blogs
  end
end
