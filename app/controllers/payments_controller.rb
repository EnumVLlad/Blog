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
  end

  def create
    if params[:blog_id].present?
      session[:paid_posts] ||= []
      session[:paid_posts] << params[:blog_id].to_i unless session[:paid_posts].include?(params[:blog_id].to_i)
    end
    redirect_to(params[:return_url].presence || blogs_path, notice: 'Оплата успішна!')
  end
end