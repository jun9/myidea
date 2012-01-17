class CreateIdeasTags < ActiveRecord::Migration
  def change
    create_table :ideas_tags,:id => false do |t|
      t.integer :tag_id
      t.integer :idea_id
    end

    add_index :ideas_tags,[:tag_id,:idea_id],:unique => true
  end
end
