class ChangePointsOfSolutions < ActiveRecord::Migration
  def change
   change_column :solutions,:points,:integer,:default => 0 
  end
end
