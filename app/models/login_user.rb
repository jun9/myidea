class LoginUser
  attr_accessor :username,:id

  def initialize(user)
    @username = user.username
    @id = user.id
  end

end
