class FollowController < ApplicationController
  before_filter :validate_login
  before_filter :set_user

  def index
    follow_ids = Twitter.friend_ids(@user.id).ids
    users = []
    i = 0
    cnt = follow_ids.size / 100
    cnt.times do |num|
      users.concat Twitter.users(follow_ids[i..i+99])
      i = i + 100
    end
    mod = (follow_ids.size % 100) - 1
    users.concat Twitter.users(follow_ids[i..i + mod])
    pp users[0]
  end
end
