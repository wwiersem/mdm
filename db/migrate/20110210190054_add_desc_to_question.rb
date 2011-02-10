class AddDescToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :description, :text
    add_column :questions, :headline, :text
  end

  def self.down
    remove_column :questions, :headline
    remove_column :questions, :description
  end
end
