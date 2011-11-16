class User < ActiveRecord::Base

  self.per_page = 3

  def User.authenticate(username, password)
    if user = find_by_username(username)
      if user.password == password
        user
      end
    end
  end
end
