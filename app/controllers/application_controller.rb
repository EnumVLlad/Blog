class ApplicationController < ActionController::Base
  before_action :set_locale

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
end
