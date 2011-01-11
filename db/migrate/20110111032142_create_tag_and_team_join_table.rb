class CreateTagAndTeamJoinTable < ActiveRecord::Migration
  def self.up
    create_table :tags_teams, :id => false do |t|
      t.integer :team_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :teams_tags
  end
end
