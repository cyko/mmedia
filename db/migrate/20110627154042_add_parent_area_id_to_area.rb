class AddParentAreaIdToArea < ActiveRecord::Migration
  def self.up
    add_column :areas, :parent_id, :integer
  end

  def self.down
    remove_column :areas, :parent_id
  end
end
