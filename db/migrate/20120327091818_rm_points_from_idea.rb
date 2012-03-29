class RmPointsFromIdea < ActiveRecord::Migration
  def change
    remove_column :ideas,:points
  end
end
