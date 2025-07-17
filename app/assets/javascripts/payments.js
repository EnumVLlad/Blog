// payments.js — Stripe Elements integration for Rails
// Используйте ENV['STRIPE_PUBLIC_KEY'] для подстановки ключа на сервере или через meta-тег
// payments.js — Stripe Elements integration for Rails
// Защита от двойного подключения
if (!window.__PAYMENTS_JS_LOADED__) {
  window.__PAYMENTS_JS_LOADED__ = true;

  const metaTag = document.querySelector('meta[name="stripe-publishable-key"]');
  if (!metaTag) {
    alert('Stripe publishable key meta tag not found!');
    throw new Error('Stripe publishable key meta tag not found!');
  }
  const STRIPE_KEY = metaTag.content;
  const stripe = Stripe(STRIPE_KEY);

  // Здесь items — это массив с одним объектом: { id, amount }
  const items = [{ id: "blog_post", amount: 1000 }]; // Можно динамически подставлять сумму

  let elements;

  function onReady(fn) {
    document.addEventListener('DOMContentLoaded', fn);
    document.addEventListener('turbolinks:load', fn);
    document.addEventListener('turbo:load', fn);
  }

  onReady(() => {
    initialize();
    document.querySelector("#payment-form").addEventListener("submit", handleSubmit);
  });

  async function initialize() {
    try {
      const response = await fetch("/payments/create_payment_intent", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ items }),
      });
      if (!response.ok) {
        const text = await response.text();
        showMessage('Ошибка сервера: ' + text);
        throw new Error(text);
      }
      const data = await response.json();
      if (!data.clientSecret) {
        showMessage('Ошибка: не получен clientSecret');
        throw new Error('No clientSecret');
      }
      const appearance = { theme: 'stripe' };
      elements = stripe.elements({ appearance, clientSecret: data.clientSecret });
      const paymentElementOptions = { layout: "accordion" };
      const paymentElement = elements.create("payment", paymentElementOptions);
      const paymentElementDiv = document.getElementById('payment-element');
      if (!paymentElementDiv) {
        console.error('Stripe: #payment-element not found in DOM!');
        showMessage('Ошибка: контейнер оплаты не найден.');
        return;
      }
      // Очищаем контейнер перед повторным mount
      paymentElementDiv.innerHTML = '';
      paymentElement.mount("#payment-element");
      console.log('Stripe: paymentElement mounted');
    } catch (err) {
      showMessage('Ошибка инициализации Stripe: ' + err.message);
    }
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setLoading(true);
    if (!elements) {
      showMessage('Stripe Elements не инициализирован');
      setLoading(false);
      return;
    }
    const { error } = await stripe.confirmPayment({
      elements,
      confirmParams: {
        return_url: window.location.origin + "/payments/complete?blog_id=" + document.getElementById('blog-id').value,
      },
    });
    if (error?.type === "card_error" || error?.type === "validation_error") {
      showMessage(error.message);
    } else if (error) {
      showMessage("An unexpected error occurred.");
    }
    setLoading(false);
  }

  function showMessage(messageText) {
    const messageContainer = document.querySelector("#payment-message");
    if (!messageContainer) return;
    messageContainer.classList.remove("hidden");
    messageContainer.textContent = messageText;
    setTimeout(function () {
      messageContainer.classList.add("hidden");
      messageContainer.textContent = "";
    }, 5000);
  }

  function setLoading(isLoading) {
    const btn = document.querySelector("#submit");
    const spinner = document.querySelector("#spinner");
    const btnText = document.querySelector("#button-text");
    if (!btn || !spinner || !btnText) return;
    if (isLoading) {
      btn.disabled = true;
      spinner.classList.remove("hidden");
      btnText.classList.add("hidden");
    } else {
      btn.disabled = false;
      spinner.classList.add("hidden");
      btnText.classList.remove("hidden");
    }
  }
}
