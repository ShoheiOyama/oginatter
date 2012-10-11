class Follow < ActiveRecord::Base
  attr_accessible :fid, :screen_name, :uid

  def self.get_follow_users(user, force=false)
    if @follow_users = Rails.cache.read("#{user.id}-follow_users")
      return @follow_users
    else
      follow_ids = Twitter.friend_ids(user.id).ids
      @follow_users = []
      i = 0
      cnt = follow_ids.size / 100
      cnt.times do |num|
        @follow_users.concat Twitter.users(follow_ids[i..i+99])
        i = i + 100
      end
      mod = (follow_ids.size % 100) - 1
      @follow_users.concat Twitter.users(follow_ids[i..i + mod])
      Rails.cache.write "#{user.id}-follow_users", @follow_users, :expire => 3600.seconds
      return @follow_users
    end
  end
end
