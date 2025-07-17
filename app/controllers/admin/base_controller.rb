# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  def current_admin_user
    current_user
  end
  helper_method :current_admin_user
end
