class AddDivisionToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :division, :string
  end

  def self.down
    remove_column :teams, :division
  end
end
