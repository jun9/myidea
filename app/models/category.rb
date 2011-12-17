class Category < ActiveRecord::Base
  has_many :ideas

  validates :name,:presence =>true
  before_destroy :check_product_count

  def check_product_count
    unless self.ideas.count == 0
      errors[:base] << I18n.t('myidea.errors.category.zero_products')
      false
    end
  end
end
