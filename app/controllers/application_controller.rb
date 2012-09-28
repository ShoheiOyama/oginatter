class ApplicationController < ActionController::Base
  require 'pp'
  before_filter :validate_current_user
  protect_from_forgery

  private

  def validate_current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      redirect_to "/"
    end
  end
end
