class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea

  self.per_page = 5

  after_create :increase_comments_count
  after_destroy :decrease_comments_count

  validates :content,:presence =>true

  def increase_comments_count
    self.idea.update_attribute("comments_count",self.idea.comments_count+1)
  end
  
  def decrease_comments_count
    self.idea.update_attribute("comments_count",self.idea.comments_count-1)
  end
  
  def self.last_page_number(conditions=nil)
    total = count :all, :conditions => conditions
    [((total - 1) / self.per_page) + 1, 1].max
  end 
end
