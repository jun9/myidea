class AddFailToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas,:fail,:string
  end
end
