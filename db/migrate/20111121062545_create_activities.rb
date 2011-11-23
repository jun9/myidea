class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :action
      t.references :user
      t.references :idea

      t.timestamps
    end
  end
end
