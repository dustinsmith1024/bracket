class AddIndexToTagTable < ActiveRecord::Migration
  def self.up
    add_index :tags, [:name, :kind], :unique => true, :name => 'by_name_and_kind'
  end

  def self.down
    remove_index :tags, :name => :by_name_and_kind
  end
end
