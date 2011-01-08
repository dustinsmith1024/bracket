class AddSeedToTeam < ActiveRecord::Migration
  def self.up
   add_column :teams, :seed, :integer
  end

  def self.down
   remove_column :teams, :seed
  end
end
