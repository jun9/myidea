class AddAttachmentAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar_file_name, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_updated_at, :datetime

    add_column :users, :description, :string
    add_column :users, :website, :string
  end
end
