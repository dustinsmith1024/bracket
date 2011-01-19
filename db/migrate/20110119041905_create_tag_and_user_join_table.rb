class CreateTagAndUserJoinTable < ActiveRecord::Migration
  def self.up
    create_table :tags_users, :id => false do |t|
      t.integer :user_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :tags_users
  end
end
