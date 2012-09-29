class Timeline < ActiveRecord::Base
  attr_accessible :body, :reply_to_id, :reply_to_name, :tweet_at, :user_id
end
