class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :uid
      t.integer :fid
      t.string :screen_name

      t.timestamps
    end
  end
end
