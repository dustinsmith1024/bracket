class AddIndexToOdds < ActiveRecord::Migration
  def self.up
    add_index :odds, [:seed_one, :seed_two], :unique => true, :name => 'by_seed_one_and_seed_two'
  end

  def self.down
    remove_index :odds, :name => :by_seed_one_and_seed_two
  end
end
