class Idea < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :user
  belongs_to :topic
  has_many :voters,:through => :votes,:source =>:user
  has_many :votes
  has_many :favorers,:through => :favors,:source =>:user
  has_many :favors
  has_many :comments,:order => "created_at"
  has_many :solutions,:order => "points desc"

  self.per_page = 30

  attr_accessor :tags_count

  validates :title,:presence =>true,:length => {:maximum => 60}
  validates :description,:presence =>true,:length => {:maximum => 2000}
  validate :tags_number_not_greater_than_three

  after_create do |idea|
    idea.user.points += 3
    idea.user.save
    idea.tags.each do |tag|
      tag.ideas_count = tag.ideas_count+1
      tag.save
    end
  end

  before_update do |idea|
    if idea.status == IDEA_STATUS_IN_THE_WORKS || idea.status == IDEA_STATUS_LAUNCHED 
      errors.add(:status,I18n.t('app.error.idea.edit'))      
    end
  end 

  searchable do
   text :title,:description
  end

  def tag_names=(names)
    self.tags = Tag.with_names(names.split(/\s+/))
  end

  def tag_names
    tags.map(&:name).join(' ')
  end

  def tags_number_not_greater_than_three
    if self.tags.length > 3
      errors.add(:tags,I18n.t('app.error.idea.tags_number'))
    end
  end
end
