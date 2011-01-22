class AddIndexToBracketTags < ActiveRecord::Migration
  def self.up
    add_index :tags_tournaments, [:tournament_id, :tag_id], :unique => true, :name => 'by_tournament_and_tag'
  end

  def self.down
    remove_index :tags_tournaments, :name => :by_tournament_and_tag
  end
end
