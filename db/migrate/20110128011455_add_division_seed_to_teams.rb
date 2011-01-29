class AddDivisionSeedToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :division_seed, :integer
  end

  def self.down
    remove_column :teams, :division_seed
  end
end
