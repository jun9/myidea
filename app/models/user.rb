class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :login,:username,:email, :password, :password_confirmation, :remember_me,:terms_of_service
  attr_accessor :login,:password_confirmation

  has_many :ideas
  has_many :voted_ideas,:through => :votes,:source =>:idea
  has_many :votes
  has_many :liked_votes,:class_name => "Vote",:conditions => {:like => true}
  has_many :unliked_votes,:class_name => "Vote",:conditions => {:like => false}
  has_many :favored_ideas,:through => :favors,:source =>:idea
  has_many :favors
  has_many :commented_ideas,:through => :comments,:source =>:idea
  has_many :comments
  has_many :activities

  self.per_page = 10

  validates :username,:uniqueness => true,:length => {:minimum => 3,:maximum => 14},:format => {:with => /\A[a-zA-Z0-9]+\z/,:message => I18n.t('myidea.errors.user.username_format')}
  validates :terms_of_service, :acceptance => true

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
 end

end
