class Topic < ActiveRecord::Base
  has_many :ideas
  validates :name,:presence =>true,:length => {:maximum => 30}
  before_destroy :check_product_count

  def check_product_count
    unless self.ideas.count == 0
      errors[:base] << I18n.t('app.error.topic.zero_ideas')
      false
    end
  end

end
