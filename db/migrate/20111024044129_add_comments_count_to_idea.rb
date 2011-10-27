class AddCommentsCountToIdea < ActiveRecord::Migration
  def change
    add_column :ideas,:comments_count,:integer,:default => 0
  end
end
