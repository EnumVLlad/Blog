document.addEventListener('DOMContentLoaded', function () {
  var paymentForm = document.querySelector('.payment-modal form');
  if (!paymentForm) return;

  paymentForm.addEventListener('submit', function (e) {
    var payBtn = paymentForm.querySelector('button[type="submit"]');
    if (!payBtn) return;
    e.preventDefault();

    setTimeout(function () {
      payBtn.disabled = true;
      payBtn.innerHTML = '<span class="pay-spinner"></span> Оплата...';
      payBtn.classList.add('pay-animating');

      setTimeout(function () {
        payBtn.innerHTML = '<span class="pay-checkmark">✔</span> Оплачено!';
        payBtn.classList.add('pay-success');
        setTimeout(function () {
          var redirectUrl = paymentForm.getAttribute('data-redirect-url');
          if (redirectUrl) {
            window.location = redirectUrl;
          } else {
            paymentForm.submit();
          }
        }, 500);
      }, 1200);
    }, 20);
  });
});
