class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :title
      t.text :description
      t.integer :points,:default => 0
      t.integer :status,:default => 0

      t.timestamps
    end
  end
end
