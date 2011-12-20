class Preference < ActiveRecord::Base
  validates :value,:presence => true
end
