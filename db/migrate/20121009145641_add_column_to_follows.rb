class AddColumnToFollows < ActiveRecord::Migration
  def change
    add_column :follows, :name, :string
  end
end
