class Idea < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :user
  belongs_to :topic
  has_many :voters,:through => :votes,:source =>:user
  has_many :votes
  has_many :favorers,:through => :favors,:source =>:user
  has_many :favors
  has_many :comments
  has_many :solutions

  self.per_page = 30

  validates :title,:presence =>true,:length => {:maximum => 60}
  validates :description,:presence =>true,:length => {:maximum => 2000}

  after_create do |idea|
    Activity.create(:action =>ACTIVITY_CREATE_IDEA,:idea => idea,:user => idea.user)
    idea.user.points += 3
    idea.user.save
    idea.tags.each do |tag|
      tag.ideas_count = tag.ideas_count+1
      tag.save
    end
  end 

  searchable do
   text :title,:description
  end

  def change_status
    case self.status
      when IDEA_STATUS_DEFAULT
        status = IDEA_STATUS_UNDER_REVIEW
      when IDEA_STATUS_UNDER_REVIEW
        status = IDEA_STATUS_REVIEWED
      when IDEA_STATUS_REVIEWED
        status = IDEA_STATUS_IN_THE_WORKS
      when IDEA_STATUS_IN_THE_WORKS
        status = IDEA_STATUS_LAUNCHED
    end
    if status
      self.update_attribute("status",status)
    else
      errors.add(:status,I18n.t('myidea.errors.idea.wrong_status'))
      false
    end
  end

  def tag_names=(names)
    self.tags = Tag.with_names(names.split(/\s+/))
  end

  def tag_names
    tags.map(&:name).join(' ')
  end

end
