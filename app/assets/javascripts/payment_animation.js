document.addEventListener('DOMContentLoaded', function () {
  var paymentForm = document.querySelector('.payment-modal form');
  if (!paymentForm) return;

  paymentForm.addEventListener('submit', function (e) {
    var payBtn = paymentForm.querySelector('button[type="submit"]');
    if (!payBtn) return;
    e.preventDefault();

    // Disable button and show loading
    payBtn.disabled = true;
    payBtn.innerHTML = '<span class="pay-spinner"></span> Оплата...';
    payBtn.classList.add('pay-animating');

    // Имитация "оплаты" и анимация галочки
    setTimeout(function () {
      payBtn.innerHTML = '<span class="pay-checkmark">✔</span> Оплачено!';
      payBtn.classList.add('pay-success');
      // Не отправляем форму автоматически, чтобы пользователь мог наблюдать анимацию
    }, 1200); // "Оплата" 1.2 сек
  });
});
