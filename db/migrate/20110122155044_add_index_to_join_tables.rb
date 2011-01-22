class AddIndexToJoinTables < ActiveRecord::Migration
  def self.up
    add_index :tags_teams, [:tag_id, :team_id], :unique => true, :name => 'by_tag_and_team'
  end

  def self.down
    remove_index :tags_teams, :name => :by_tag_and_team
  end
end
