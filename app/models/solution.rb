class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea,:counter_cache => true

  validates :content,:presence =>true,:length => {:maximum => 1000}
  validates :title,:presence =>true,:length => {:maximum => 60}
end
