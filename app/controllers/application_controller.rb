class ApplicationController < ActionController::Base
  include Pundit

  # For ActiveAdmin authentication
  def authenticate_admin_user!
    authenticate_user!
    unless current_user&.admin?
      redirect_to root_path, alert: "Not authorized"
    end
  end

  # For ActiveAdmin compatibility
  def current_admin_user
    current_user
  end
  helper_method :current_admin_user

  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def after_sign_up_path_for(resource)
    root_path
  end

  private
  def set_locale
    I18n.locale = params[:locale] || cookies[:locale] || I18n.default_locale
    I18n.locale = :en unless %w(en uk).include?(I18n.locale.to_s)
    cookies[:locale] = I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def render_not_found
    render file: Rails.root.join('public', '404.html'), status: :not_found, layout: false
  end

  # Alias for ActiveAdmin compatibility
  def current_admin_user
    current_user
  end
  helper_method :current_admin_user
end
