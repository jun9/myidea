class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read,:search,:tab],Idea
    can :show, User
    if user
      can [:promotion,:create,:like,:unlike,:favoriate,:unfavoriate,:preview], Idea
      can :manage, Comment
      can :manage, Solution
      can [:edit,:update], User

      if user.admin?
        can :manage, :all
      end
    end
  end
end
