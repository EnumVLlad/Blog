class Blog < ApplicationRecord
  CATEGORY_OPTIONS = %w[travel relax cars pets food sport work other]

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :user

  validates :category, inclusion: { in: CATEGORY_OPTIONS }

  after_create :notify_telegram_channel

  def localized_category
    I18n.t("categories.", default: category)
  end

  private

  def notify_telegram_channel
    post_url = "http://localhost:3000"
    TelegramNotifier.notify_new_post(title, post_url)
  end
end
