class AddSolutionsCountToIdea < ActiveRecord::Migration
  def change
    add_column :ideas,:solutions_count,:integer,:default => 0
  end
end
