class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.string :title
      t.text :content
      t.integer :points
      t.references :user
      t.references :idea 

      t.timestamps
    end
  end
end
