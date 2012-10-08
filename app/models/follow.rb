class Follow < ActiveRecord::Base
  attr_accessible :fid, :screen_name, :uid

  def self.get_follow_users(user, force=false)
    if !force && self.where(:uid => user.id).first 
      return self.where(:uid => user.id).all
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
      @follow_users.each do |follow_user|
        unless self.where(:uid => user.id, :fid => follow_user.id, :screen_name => follow_user.screen_name).first
          self.create(:uid => user.id, :fid => follow_user.id, :screen_name => follow_user.screen_name)
        end
      end
      return @follow_users
    end
  end
end
