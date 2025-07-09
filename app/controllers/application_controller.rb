class ApplicationController < ActionController::Base
  include Pundit
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
end
