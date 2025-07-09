require 'rails_helper'
require 'stripe'
require 'webmock/rspec'
require 'ostruct'

class UniversalMock < OpenStruct
  def method_missing(name, *args, &block)
    return false if name.to_s.end_with?('?')
    UniversalMock.new
  end

  def [](key)
    UniversalMock.new
  end

  def nil?
    false
  end
end

RSpec.describe 'Pay/Stripe integration', type: :model do
  let(:user) { create(:user) }

  before do
    ENV['STRIPE_API_KEY'] = 'sk_test_123'
    Stripe.api_key = 'sk_test_123'
    WebMock.disable_net_connect!(allow_localhost: true)
    stub_request(:post, /api.stripe.com\/v1\/customers/).to_return(
      status: 200,
      body: '{"id": "cus_test123", "object": "customer"}',
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:post, /api.stripe.com\/v1\/subscriptions/).to_return(
      status: 200,
      body: {
        id: "sub_test123",
        object: "subscription",
        status: "active",
        customer: { id: "cus_test123", object: "customer" }
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:any, /api.stripe.com/).to_return(
      status: 200,
      body: '{"id": "generic_id", "object": "generic"}',
      headers: { 'Content-Type' => 'application/json' }
    )
    allow(Stripe::Subscription).to receive(:create).and_return(
      UniversalMock.new(
        id: "sub_test123",
        object: "subscription",
        status: "active",
        customer: UniversalMock.new(id: "cus_test123", object: "customer"),
        incomplete?: false,
        trialing?: false,
        active?: true,
        latest_invoice: UniversalMock.new(
          id: "in_test123",
          object: "invoice",
          status: "paid",
          incomplete?: false,
          payment_intent: UniversalMock.new(
            id: "pi_test123",
            object: "payment_intent",
            status: "succeeded",
            incomplete?: false
          )
        )
      )
    )
  end

  it 'создаёт Pay::Customer для пользователя' do
    user.set_payment_processor(:stripe)
    customer = user.payment_processor
    expect(customer).to be_present
    expect(customer.processor).to eq('stripe')
  end
end
