class ChangeStatusOfIdeas < ActiveRecord::Migration
  def change
   change_column :ideas,:status,:string
  end
end
