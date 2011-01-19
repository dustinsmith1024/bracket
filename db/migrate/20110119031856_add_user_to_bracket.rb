class AddUserToBracket < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :user_id, :integer
  end

  def self.down
    remove_column :tournaments, :user_id
  end
end
