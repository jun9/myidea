class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read,:search,:tab,:tag],Idea
    can :show, User
    if user
      can [:promotion,:create,:update,:like,:unlike,:favoriate,:unfavoriate], Idea
      can :manage, Comment
      can :manage, Solution
      can [:edit,:update], User

      if user.admin?
        can :manage, :all
      end
    end
  end
end
