class AddTopicToIdea < ActiveRecord::Migration
  def change
    add_column :ideas,:topic_id,:integer
  end
end
