#coding: utf-8
class ApplicationController < ActionController::Base
  require 'pp'
  before_filter :validate_current_user
  protect_from_forgery

  WDAY = ["日", "月", "火", "水", "木", "金", "土"]

  private

  def validate_current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      redirect_to "/"
    end
  end

  def set_twitter_user
    @user = Twitter.user if @user.nil?
  end

  def set_timelines
    set_user if @user.nil?
    @timelines = Twitter.user_timeline(@user.screen_name, :count => 200) if @timelines.nil?
  end

  def set_date
    set_timelines if @timelines.nil?
    @since = @until = Time.current - 24*60*60
    @timelines.each do |tweet|
      @since = tweet.created_at if @since > tweet.created_at
      @until = tweet.created_at if @until < tweet.created_at
    end
    @since = @since.strftime("%m-%d")
    @until = @until.strftime("%m-%d")
  end
end
