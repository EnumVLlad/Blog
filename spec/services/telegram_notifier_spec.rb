require 'rails_helper'

RSpec.describe TelegramNotifier do
  describe '.notify_new_post' do
    let(:title) { 'Test Title' }
    let(:url) { 'http://test.url/post/1' }

    before do
      stub_const('TelegramNotifier::BOT_TOKEN', 'fake-token')
      stub_const('TelegramNotifier::CHAT_ID', 'fake-chat-id')
    end

    it 'sends a message to Telegram API' do
      expect(Net::HTTP).to receive(:post_form) do |uri, params|
        expect(uri.to_s).to eq('https://api.telegram.org/botfake-token/sendMessage')
        expect(params[:chat_id]).to eq('fake-chat-id')
        expect(params[:text]).to include(title)
        expect(params[:text]).to include(url)
        expect(params[:parse_mode]).to eq('HTML')
        double(body: '{"ok":true,"result":{}}')
      end

      described_class.notify_new_post(title, url)
    end

    it 'logs error if response contains error' do
      allow(Net::HTTP).to receive(:post_form).and_return(double(body: '{"error":"something went wrong"}'))
      expect(Rails.logger).to receive(:error).with(/ERROR/)
      described_class.notify_new_post(title, url)
    end

    it 'logs exception if request fails' do
      allow(Net::HTTP).to receive(:post_form).and_raise(StandardError.new('connection failed'))
      expect(Rails.logger).to receive(:error).with(/Exception: connection failed/)
      described_class.notify_new_post(title, url)
    end
  end
end
