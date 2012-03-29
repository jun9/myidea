class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea,:counter_cache => true

  self.per_page = 20

  validates :content,:presence =>true,:length => {:maximum => 1000}

  after_create do |comment|
    Activity.create(:action =>ACTIVITY_COMMENT_IDEA,:idea => comment.idea,:user => comment.user)
    comment.user.points += 1
    comment.user.save
  end 

end
