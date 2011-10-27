class Idea < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_and_belongs_to_many :likers ,:class_name => "User",:join_table => "users_like_ideas"
  has_many :comments

  self.per_page = 5

  validates :title,:presence =>true,:length => {:maximum => 30}
  validates :description,:presence =>true,:length => {:maximum => 1000}
  validates :category_id,:presence =>true
end
