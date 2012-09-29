class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.string :user_id
      t.string :reply_to_id
      t.string :reply_to_name
      t.date :tweet_at
      t.string :body

      t.timestamps
    end
  end
end
