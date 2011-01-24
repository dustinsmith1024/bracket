class CreateOdds < ActiveRecord::Migration
  def self.up
    create_table :odds do |t|
      t.integer :seed_one
      t.integer :seed_two
      t.integer :chance

      t.timestamps
    end
  end

  def self.down
    drop_table :odds
  end
end
