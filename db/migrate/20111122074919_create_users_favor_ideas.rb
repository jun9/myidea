class CreateUsersFavorIdeas < ActiveRecord::Migration
  def change
    create_table :favors do |t|
      t.integer :user_id
      t.integer :idea_id

      t.timestamps
    end

    add_index :favors,[:user_id,:idea_id],:unique => true
  end
end
