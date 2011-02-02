class AddPluralNameToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :plural_name, :string
  end

  def self.down
    remove_column :tags, :plural_name
  end
end
