// complete.js — статус платежа через Stripe.js
const STRIPE_KEY = document.querySelector('meta[name="stripe-publishable-key"]').content;
const stripe = Stripe(STRIPE_KEY);

const SuccessIcon = '<svg width="16" height="14" ...></svg>';
const ErrorIcon = '<svg width="16" height="16" ...></svg>';
const InfoIcon = '<svg width="14" height="14" ...></svg>';

function setPaymentDetails(intent) {
  let statusText = "Something went wrong, please try again.";
  let iconColor = "#DF1B41";
  let icon = ErrorIcon;
  if (!intent) { setErrorState(); return; }
  switch (intent.status) {
    case "succeeded": statusText = "Payment succeeded"; iconColor = "#30B130"; icon = SuccessIcon; break;
    case "processing": statusText = "Your payment is processing."; iconColor = "#6D6E78"; icon = InfoIcon; break;
    case "requires_payment_method": statusText = "Your payment was not successful, please try again."; break;
    default: break;
  }
  document.querySelector("#status-icon").style.backgroundColor = iconColor;
  document.querySelector("#status-icon").innerHTML = icon;
  document.querySelector("#status-text").textContent= statusText;
  document.querySelector("#intent-id").textContent = intent.id;
  document.querySelector("#intent-status").textContent = intent.status;
  document.querySelector("#view-details").href = `https://dashboard.stripe.com/payments/${intent.id}`;
}

function setErrorState() {
  document.querySelector("#status-icon").style.backgroundColor = "#DF1B41";
  document.querySelector("#status-icon").innerHTML = ErrorIcon;
  document.querySelector("#status-text").textContent= "Something went wrong, please try again.";
  document.querySelector("#details-table").classList.add("hidden");
  document.querySelector("#view-details").classList.add("hidden");
}

checkStatus();

async function checkStatus() {
  const clientSecret = new URLSearchParams(window.location.search).get(
    "payment_intent_client_secret"
  );
  if (!clientSecret) { setErrorState(); return; }
  const { paymentIntent } = await stripe.retrievePaymentIntent(clientSecret);
  setPaymentDetails(paymentIntent);
}
