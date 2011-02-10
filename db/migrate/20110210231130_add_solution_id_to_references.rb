class AddSolutionIdToReferences < ActiveRecord::Migration
  def self.up
    add_column :references, :solution_id, :integer
  end

  def self.down
    remove_column :references, :solution_id
  end
end
