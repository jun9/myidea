class Idea < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :voters,:through => :votes,:source =>:user
  has_many :votes
  has_many :favorers,:through => :favors,:source =>:user
  has_many :favors
  has_many :comments

  self.per_page = 5

  validates :title,:presence =>true,:length => {:maximum => 30}
  validates :description,:presence =>true,:length => {:maximum => 1000}
  validates :category_id,:presence =>true

  after_create do |idea|
    Activity.create(:action =>ACTIVITY_CREATE_IDEA,:idea => idea,:user => idea.user)
    idea.user.points += 3
    idea.user.save
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
      errors.add(:status,I18n.t('errors.idea.wrong_status'))
      false
    end
  end

end
