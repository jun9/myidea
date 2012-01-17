class AddInitData < ActiveRecord::Migration
  def up
    User.delete_all
    User.create(:username => "admin",:email => "admin@example.com",:password =>"123456",:password_confirmation => "123456")
    user = User.find_by_username('admin')
    user.admin = true
    user.save
    
    Preference.delete_all
    Preference.create(:name =>PREFERENCE_SITE_NAME,:value => 'No Site Name')
  end

  def down
    User.delete_all
    Preference.delete_all
  end
end
