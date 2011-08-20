class AddNameAndCommentToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :name, :string
    add_column :tasks, :comment, :text
  end

  def self.down
    remove_column :task, :name
    remove_column :task, :comment
  end
end
