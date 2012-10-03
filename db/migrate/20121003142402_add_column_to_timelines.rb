class AddColumnToTimelines < ActiveRecord::Migration
  def change
    add_column :timelines, :timeline_id, :integer
    add_column :timelines, :user_name, :string
  end
end
