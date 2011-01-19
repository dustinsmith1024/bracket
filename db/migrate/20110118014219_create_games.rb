class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.references :tournament
      t.references :team_one
      t.references :team_two
      t.references :winner

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
