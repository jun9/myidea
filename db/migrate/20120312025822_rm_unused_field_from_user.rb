class RmUnusedFieldFromUser < ActiveRecord::Migration
  def change
    remove_column :users,:hashed_password
    remove_column :users,:salt
    remove_column :users,:active
  end
end
