class CreateUsersLikeIdeas < ActiveRecord::Migration
  def change
    create_table :users_like_ideas,:id => false do |t|
      t.integer :user_id
      t.integer :idea_id
    end

    add_index :users_like_ideas,[:user_id,:idea_id],:unique => true
  end
end
