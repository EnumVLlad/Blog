require_dependency Rails.root.join('app/services/stripe/payment_intent_service').to_s

class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :create_payment_intent]

  def new
  end

  def create_payment_intent
    items = params[:items] || []
    currency = params[:currency] || 'usd'
    intent = Stripe::PaymentIntentService.create_payment_intent(items: items, currency: currency)
    if intent.is_a?(Stripe::StripeError)
      render json: { error: intent.message }, status: 400
    else
      render json: { clientSecret: intent.client_secret }
    end
  end

  def complete
    Rails.logger.info "[PAYMENTS#COMPLETE] user_signed_in?=#{user_signed_in?}, current_user_id=#{current_user&.id}, blog_id=#{params[:blog_id].inspect}, params=#{params.inspect}"
    if params[:blog_id].present? && user_signed_in?
      blog = Blog.find_by(id: params[:blog_id])
      Rails.logger.info "[PAYMENTS#COMPLETE] blog found: #{blog.present?}, already_accessible=#{blog && current_user.accessible_blogs.exists?(blog.id)}"
      if blog && !current_user.accessible_blogs.exists?(blog.id)
        current_user.blog_accesses.create!(blog: blog)
        Rails.logger.info "[PAYMENTS#COMPLETE] access granted"
      end
      redirect_to blog_path(params[:blog_id]), notice: 'Оплата успішна!'
    else
      Rails.logger.info "[PAYMENTS#COMPLETE] rendering :complete (not logged in or no blog_id)"
      render :complete
    end
  end

  def create
  if params[:blog_id].present?
    session[:paid_posts] ||= []
    session[:paid_posts] << params[:blog_id].to_i unless session[:paid_posts].include?(params[:blog_id].to_i)
    redirect_to blog_path(params[:blog_id]), notice: 'Оплата успішна!'
  else
    redirect_to(params[:return_url].presence || blogs_path, notice: 'Оплата успішна!')
  end
end
end