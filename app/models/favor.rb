class Favor < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea 
  
  after_create do |favor|
    Activity.create(:action =>ACTIVITY_FAVORITE_IDEA,:idea => favor.idea,:user => favor.user)
  end

  after_destroy do |favor|
    Activity.create(:action =>ACTIVITY_UNFAVORITE_IDEA,:idea => favor.idea,:user => favor.user)
  end
end
