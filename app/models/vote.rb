class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea 
  
  after_create do |vote|
    vote.user.points += 1
    vote.user.save
  end 
end
