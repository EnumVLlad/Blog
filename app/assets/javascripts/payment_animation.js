document.addEventListener('DOMContentLoaded', function () {
  var paymentForm = document.querySelector('.payment-modal form');
  if (!paymentForm) return;

  paymentForm.addEventListener('submit', function (e) {
    var payBtn = paymentForm.querySelector('button[type="submit"]');
    if (!payBtn) return;
    e.preventDefault();

    // Показываем крутилку и текст 'Оплата...' в следующем event loop
    setTimeout(function () {
      payBtn.disabled = true;
      payBtn.innerHTML = '<span class="pay-spinner"></span> Оплата...';
      payBtn.classList.add('pay-animating');

      // Имитация "оплаты" и анимация галочки
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
        }, 500); // 0.5 сек после галочки
      }, 1200); // "Оплата" 1.2 сек
    }, 20); // Дать браузеру время отрисовать крутилку
  });
});
