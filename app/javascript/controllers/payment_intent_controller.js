import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["error", "errorMessage", "success", "successMessage", "form", "button", "name", "card", "cardFields"];
  static values = {
    clientSecret: String,
    customer: String,
    status: String,
    errorMessage: String,
    successMessage: String,
    complete: Boolean,
    processing: Boolean
  };

  async connect() {
    console.log('Stripe Stimulus connect');
    const stripeKey = document.querySelector('meta[name="stripe-publishable-key"]')?.content;
    if (!stripeKey) {
      console.error('Stripe publishable key meta tag not found!');
      return;
    }
    await this.loadStripeJsOnce();
    this.stripe = window.Stripe(stripeKey);
    this._stripeMounted = false;
  }

  loadStripeJsOnce() {
    return new Promise((resolve, reject) => {
      if (window.Stripe) {
        resolve();
        return;
      }
      const script = document.createElement('script');
      script.src = "https://js.stripe.com/v3/";
      script.async = true;
      script.onload = resolve;
      script.onerror = reject;
      document.head.appendChild(script);
    });
  }

  statusValueChanged() {
    if (!this._stripeMounted && this.hasCardTarget && this.stripe) {
      this.elements = this.stripe.elements({clientSecret: this.clientSecretValue});
      this.payment = this.elements.create('payment');
      this.payment.mount(this.cardTarget);
      this._stripeMounted = true;
      console.log('Stripe Elements mounted');
    }
    switch(this.statusValue) {
      case "requires_action":
        this.processingValue = true;
        this.stripe.confirmPayment({clientSecret: this.clientSecretValue, confirmParams: { return_url: document.location.href }}).then(this.handleConfirmResult.bind(this));
        break;
      case "requires_payment_method":
        this.cardFieldsTarget.classList.toggle("hidden", false);
        break;
    }
  }

  confirmPayment() {
    this.processingValue = true;
    this.stripe.confirmPayment({elements: this.elements, confirmParams: { return_url: document.location.href }}).then(this.handleConfirmResult.bind(this));
  }

  handleConfirmResult(result) {
    this.processingValue = false;

    if (result.error) {
      if (result.error.code === 'parameter_invalid_empty' &&
        result.error.param === 'payment_method_data[billing_details][name]') {
        this.errorMessageValue = "Пожалуйста, введите имя";
      } else {
        this.errorMessageValue = result.error.message;
        this.statusValue = result.error.payment_intent.status;
      }
    } else {
      this.completeValue = true;
      this.successMessageValue = "Оплата прошла успешно!";
    }
  }

  completeValueChanged() {
    if (this.hasFormTarget) {
      this.formTarget.classList.toggle("hidden", this.completeValue);
    }
  }

  processingValueChanged() {
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = this.processingValue;
      this.buttonTarget.classList.toggle("bg-blue-400", this.processingValue);
      this.buttonTarget.classList.toggle("bg-blue-500", !this.processingValue);
    }
  }

  errorMessageValueChanged() {
    this.errorMessageTarget.textContent = this.errorMessageValue;
    const enabled = (this.errorMessageValue != '');
    this.errorTarget.classList.toggle("flex", enabled);
    this.errorTarget.classList.toggle("hidden", !enabled);
  }

  successMessageValueChanged() {
    this.successMessageTarget.textContent = this.successMessageValue;
    const enabled = (this.successMessageValue != '');
    this.successTarget.classList.toggle("flex", enabled);
    this.successTarget.classList.toggle("hidden", !enabled);
  }
}
