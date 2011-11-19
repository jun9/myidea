require 'digest/sha2'

class User < ActiveRecord::Base

  self.per_page = 3

  attr_accessor :password_confirmation 
  attr_reader :password

  validates :username,:presence =>true,:uniqueness => true,:length => {:minimum => 3,:maximum => 14},:format => {:with => /\A[a-zA-Z0-9]+\z/,:message => I18n.t('errors.user.username_format')}
  validates :password,:presence => true,:confirmation => true,:length => {:minimum => 6,:maximum => 128}
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
