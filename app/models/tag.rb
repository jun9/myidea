class Tag < ActiveRecord::Base
  has_and_belongs_to_many :ideas

  def self.with_names(names)
    names.map do |name|
      Tag.find_or_create_by_name(name)
    end
  end
end
