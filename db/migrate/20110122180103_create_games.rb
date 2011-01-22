class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :number
      t.references :tournament

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
