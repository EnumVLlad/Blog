class Blog < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user


  after_create :notify_telegram_channel

  private

  def notify_telegram_channel
    # Здесь формируем url поста (замените на реальный путь, если понадобится)
    post_url = "http://localhost:3000"
    TelegramNotifier.notify_new_post(title, post_url)
  end
end
