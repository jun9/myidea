class AddPickToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:pick,:boolean,:default => false
  end
end
