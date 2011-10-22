class User < ActiveRecord::Base
  has_and_belongs_to_many :likedIdeas ,:class_name => "Idea",:join_table => "users_like_ideas"
  def User.authenticate(username, password)
    if user = find_by_username(username)
      if user.password == password
        user
      end
    end
  end
end
