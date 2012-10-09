#coding: utf-8
class ApplicationController < ActionController::Base
  require 'pp'
  helper_method :current_user
  
  protect_from_forgery

  WDAY = ["日", "月", "火", "水", "木", "金", "土"]

  private

  def validate_login
    if current_user.nil?
      redirect_to "login#index"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_user(screen_name=nil)
    if @user = Rails.cache.read("#{session[:user_id]}-user")
      return @user
    else
      @user = Twitter.user
      Rails.cache.write "#{session[:user_id]}-user", @user
    end
  end

  def set_timelines
    @timelines = Timeline.get_user_all_timelines(@user)
      # @timelines = Twitter.user_timeline(@user.screen_name, :count => 200, :page => 4)
  end

  def set_date
    @timelines.each do |tweet|
      if @since.nil? && @until.nil?
        @since = @until = tweet.created_at
      else
        @since = tweet.created_at if @since > tweet.created_at
        @until = tweet.created_at if @until < tweet.created_at
      end
    end
    @since = @since.strftime("%m-%d")
    @until = @until.strftime("%m-%d")
  end
end
