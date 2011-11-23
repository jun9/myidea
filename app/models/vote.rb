class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea 
  
  after_create do |vote|
    if vote.like
      Activity.create(:action =>ACTIVITY_LIKE_IDEA,:idea => vote.idea,:user => vote.user)
    else
      Activity.create(:action =>ACTIVITY_UNLIKE_IDEA,:idea => vote.idea,:user => vote.user)
    end
  end 
end
