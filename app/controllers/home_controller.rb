class HomeController < ApplicationController
  before_filter :set_twitter_user
  before_filter :set_timelines

  def index
    @user = Twitter.user
    @timelines = Twitter.user_timeline(@user.screen_name, :count => 200)
    @reply_map = {}
    @timelines.each do |timeline|
      unless timeline.in_reply_to_screen_name.nil?
        if @reply_map[timeline.in_reply_to_screen_name].nil?
          @reply_map[timeline.in_reply_to_screen_name] = 1
        else
          @reply_map[timeline.in_reply_to_screen_name] += 1
        end
      end
    end
    unless @reply_map.blank?
      @reply_map = @reply_map.to_a.sort{|a, b|
        (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
      }.slice(0,10)
    end
  end

  def day_tweet
    @day_tweet_map = {}
    @timelines.each do |tweet|
      if @day_tweet_map[tweet.created_at.strftime("%m-%d")].nil?
        @day_tweet_map[tweet.created_at.strftime("%m-%d")] = 1
      else
        @day_tweet_map[tweet.created_at.strftime("%m-%d")] += 1
      end
    end
    @date = @count = []
    @day_tweet_map.to_a.each do |(date, count)|
      @date << date
      @count << count
    end
    @chart = Graph.create_spline("tweet_count_a_day", @date, "tweet_count", @count)
  end

  private 

  def set_twitter_user
    @user = Twitter.user
  end

  def set_timelines
    @timelines = Twitter.user_timeline(@user.screen_name)
  end
end
