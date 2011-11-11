class CreateUsersVoteIdeas < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :idea_id
      t.boolean :like
    end

    add_index :votes,[:user_id,:idea_id],:unique => true
  end
end
