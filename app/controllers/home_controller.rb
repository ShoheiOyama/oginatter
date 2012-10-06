class HomeController < ApplicationController
  before_filter :validate_login
  before_filter :set_user
  before_filter :set_timelines
  before_filter :set_date

  def reply
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
    @reply_ranking = @reply_map.to_a.sort{|a, b|
      (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
    }
    @reply_top_ten = @reply_ranking.slice(0, 10)
    @categories = []
    @data = []
    @reply_top_ten.each do |(screen_name, count)|
      @categories << screen_name
      @data << count
    end
    @chart = Graph.create_column("reply_count", @categories, "count", @data)
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
    @categories = @day_tweet_map.keys
    @data = @day_tweet_map.values
    @chart = Graph.create_spline("tweet_count_a_day", @categories.reverse, "tweet_count", @data.reverse)
  end

  def week_tweet
    @week_tweet_map = {}
    @timelines.each do |tweet|
      if @week_tweet_map[WDAY[tweet.created_at.wday]].nil?
        @week_tweet_map[WDAY[tweet.created_at.wday]] = 1
      else 
        @week_tweet_map[WDAY[tweet.created_at.wday]] += 1
      end
    end
    @categories = @week_tweet_map.keys
    @data = @week_tweet_map.values
    @chart = Graph.create_column("week_tweet_count", @categories.reverse, "tweet_count", @data.reverse)
  end
end
