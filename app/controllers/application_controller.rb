#coding: utf-8
class ApplicationController < ActionController::Base
  require 'pp'
  before_filter :validate_current_user

  protect_from_forgery

  WDAY = ["日", "月", "火", "水", "木", "金", "土"]

  private

  def validate_current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_user(screen_name=nil)
    if screen_name.nil?
      @user = Twitter.user
    else
      @user = Twitter.user(screen_name)
    end
  end

  # def set_timelines
  #   set_current_user if @current_user.nil?
  #   if session[:get_timeline].nil?
  #     @timelines = Twitter.user_timeline(@user.screen_name, :count => 200)
  #     @timelines.each do |tweet|
  #       #TO_DO
  #       Timeline.create(:user_id => tweet.user_id
  #                       :reply_to_id => tweet.in_reply_to_id,
  #                       :reply_to_name => tweet.in_reply_to_screen_name
  #                       :body => tweet.body
  #                       :tweet_at => tweet.created_at)
  #     end
  # end

  def set_timelines
    @timelines = Timeline.get_user_timelines(@user, 200, 2)
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
