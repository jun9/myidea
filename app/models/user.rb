require 'digest/sha2'

class User < ActiveRecord::Base
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

  self.per_page = 3

  attr_accessor :password_confirmation,:check_password
  attr_reader :password

  validates :username,:presence =>true,:uniqueness => true,:length => {:minimum => 3,:maximum => 14},:format => {:with => /\A[a-zA-Z0-9]+\z/,:message => I18n.t('errors.user.username_format')}
  validates :password,:presence => true,:confirmation => true,:length => {:minimum => 6,:maximum => 30},:if => "check_password"
  validates :email,:presence => true,:uniqueness => true,:length => {:maximum => 128},:format => {:with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/}

  attr_accessible :username, :email, :password, :password_confirmation

  def User.authenticate(account, password) 
    if user = where("username = ? OR email = ?",account,account).first
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end 
    end
  end

  def password=(password)
    @password = password
    if password.present? 
      generate_salt 
      self.hashed_password = self.class.encrypt_password(password, salt)
    end 
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "myidea" + salt)
  end

  private
  def generate_salt 
    self.salt = self.object_id.to_s + rand.to_s
  end

end
