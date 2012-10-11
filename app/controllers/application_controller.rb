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
    @since = params[:since].to_time if params[:since]
    @until = params[:until].to_time if params[:until]
    if @since.nil? && @until.nil?
      @timelines = Timeline.get_user_all_timelines(@user)
    else
      @timelines = Timeline.get_timelines_by_time(@user, @since, @until)
    end
  end

  def set_date
    if @since.nil? && @until.nil?
      @timelines.each do |tweet|
        if @since.nil? && @until.nil?
          @since = @until = tweet.created_at
        else
          @since = tweet.created_at if @since > tweet.created_at
          @until = tweet.created_at if @until < tweet.created_at
        end
      end
    end
    @since = @since.strftime("%Y-%m-%d")
    @until = @until.strftime("%Y-%m-%d")
  end
end
