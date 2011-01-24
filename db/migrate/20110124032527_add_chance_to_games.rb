class AddChanceToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :original_odds, :integer
    add_column :games, :adjusted_odds, :integer
  end

  def self.down
    remove_column :games, :original_odds
    remove_column :games, :adjusted_odds
  end
end
