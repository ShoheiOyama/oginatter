class Timeline < ActiveRecord::Base
  attr_accessible :body, :reply_to_id, :reply_to_name, :tweet_at, :user_id

  def self.save_user_timelines(user)
  end

  def self.get_user_timelines(user, count=200, page=1)
    return if user.nil?
    unless timelines = Rails.cache.read("#{user.id}-timeline-#{page}")
      timelines = Twitter.user_timeline(user.screen_name, :count => count, :page => page)
      Rails.cache.write "#{user.id}-timeline-#{page}", timelines
    end
    return timelines
  end

  def self.get_user_all_timelines(user)
    return if user.nil?
    if timelines = Rails.cache.read("#{user.id}-timelines")
      pp "cache"
      return timelines
    else
      tweet_count = user.tweet_count
      return nil if tweet_count == 0
      if tweet_count <= 200
        timelines = self.get_user_timelines(user, tweet_count)
      else 
        timelines = []
        cnt = (tweet_count / 200) + 1
        cnt.times do |cnt|
          timelines.concat self.get_user_timelines(user, 200, cnt)
        end
        rest_count = tweet_count - cnt*200
        timelines.concat self.get_user_timelines(user, rest_count, cnt+1)
      end
      pp user.id
      Rails.cache.write "#{user.id}-timelines", timelines
    end
    return timelines
  end
end