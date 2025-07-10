module Stripe
  class PaymentIntentService
    def self.create_payment_intent(items:, currency: 'usd')
      ::Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      amount = items.sum { |i| i[:amount].to_i }
      payment_intent = ::Stripe::PaymentIntent.create(
        amount: amount,
        currency: currency,
        automatic_payment_methods: { enabled: true }
      )
      payment_intent
    rescue ::Stripe::StripeError => e
      e
    end
  end
end
