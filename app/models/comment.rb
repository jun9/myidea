class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea,:counter_cache => true

  validates :content,:presence =>true,:length => {:maximum => 1000}

  after_create do |comment|
    comment.user.points += 1
    comment.user.save
  end 

end
