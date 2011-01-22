class CreateBracketTagJoinTable < ActiveRecord::Migration
  def self.up
    create_table :tags_tournaments, :id => false do |t|
      t.integer :tournament_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :tags_tournaments
  end
end
