class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea

  self.per_page = 5

  validates :content,:presence =>true

  after_create do |comment|
    comment.idea.update_attribute("comments_count",self.idea.comments_count+1)
    Activity.create(:action =>ACTIVITY_COMMENT_IDEA,:idea => comment.idea,:user => comment.user)
    comment.user.points += 1
    comment.user.save
  end 

  def self.last_page_number(conditions=nil)
    total = count :all, :conditions => conditions
    [((total - 1) / self.per_page) + 1, 1].max
  end 
end
