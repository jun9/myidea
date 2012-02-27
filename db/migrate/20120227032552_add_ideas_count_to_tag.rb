class AddIdeasCountToTag < ActiveRecord::Migration
  def change
    add_column :tags,:ideas_count,:integer,:default => 0
  end
end
