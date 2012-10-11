class Timeline < ActiveRecord::Base

  def self.save_user_timelines(user)
  end

  def self.get_user_timelines(user, count=200, page=1)
    return if user.nil?
    unless timelines = Rails.cache.read("#{user.id}-timeline-#{page}")
      timelines = Twitter.user_timeline(user.screen_name, :count => count, :page => page)
      Rails.cache.write "#{user.id}-timeline-#{page}", timelines, :expire => 600.seconds
    end
    return timelines
  end

  def self.get_user_all_timelines(user)
    return if user.nil?
    timelines = []
    tweet_count = user.tweet_count
    return nil if tweet_count == 0
    tweet_count = 4000 if tweet_count >= 4000
    cnt = (tweet_count / 200) + 1
    rest_count = tweet_count - cnt*200
    cnt.times do |num|
      timelines.concat self.get_user_timelines(user, 200, num+1)
    end
    return timelines
  end

  def self.get_timelines_by_time(user, stime=nil, etime=nil)
    return if user.nil?
    return if stime.nil? && etime.nil?
    if stime.nil?
      stime = Time.new(0)
    else etime.nil?
      etime = Time.now
    end
    timelines = self.get_user_all_timelines(user)
    @timelines = []
    timelines.each do |tweet|
      if tweet.created_at > stime && tweet.created_at < etime
        @timelines << tweet
      end
    end
    return @timelines
  end
end