class AddIndexToUsersTagTable < ActiveRecord::Migration
  def self.up
    add_index :tags_users, [:tag_id, :user_id], :unique => true, :name => 'by_tag_and_user'
  end

  def self.down
    remove_index :tags_users, :name => :by_tag_and_user
  end
end
