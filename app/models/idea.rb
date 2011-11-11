class Idea < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :voters,:through => :votes,:source =>:user
  has_many :votes
  has_many :comments

  self.per_page = 5

  validates :title,:presence =>true,:length => {:maximum => 30}
  validates :description,:presence =>true,:length => {:maximum => 1000}
  validates :category_id,:presence =>true

  searchable do
   text :title,:description
  end
end
