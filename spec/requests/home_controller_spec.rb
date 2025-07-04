require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "redirects to login (302) or success if opened" do
      get root_path
      expect([200, 302]).to include(response.status)
    end
  end
end
