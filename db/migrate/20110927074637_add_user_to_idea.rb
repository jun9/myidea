class AddUserToIdea < ActiveRecord::Migration
  def change
    add_column :ideas,:user_id,:integer
  end
end
