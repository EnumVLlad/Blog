require 'net/http'
require 'uri'
require 'json'

class TelegramNotifier
  BOT_TOKEN = '7272994970:AAF5PagvxFqv7sAjpUsDlB4P6EI7cZ0JmWE'
  CHAT_ID = '-1002835259112'

  # Метод для отправки уведомления
  def self.notify_new_post(title, url)
    message = "<b>#{title}</b>\n\nесли хочешь почитать — переходи к нам!\n#{url}"
    uri = URI("https://api.telegram.org/bot#{BOT_TOKEN}/sendMessage")
    params = {
      chat_id: CHAT_ID,
      text: message,
      parse_mode: 'HTML'
    }
    begin
      response = Net::HTTP.post_form(uri, params)
      Rails.logger.info("[TelegramNotifier] Telegram API response: #{response.body}")
      puts "[TelegramNotifier] Telegram API response: #{response.body}"
      if response.body.include?("error")
        Rails.logger.error("[TelegramNotifier] ERROR: #{response.body}")
        puts "[TelegramNotifier] ERROR: #{response.body}"
      end
    rescue => e
      Rails.logger.error("[TelegramNotifier] Exception: #{e.message}")
      puts "[TelegramNotifier] Exception: #{e.message}"
    end
  end
end
