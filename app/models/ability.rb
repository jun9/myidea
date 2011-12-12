class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read,:search,:tab],Idea
    can [:login,:new,:create,:show,:act],User
    if user
      can [:promotion,:new,:create,:like,:unlike,:favoriate,:unfavoriate,:preview], Idea
      can :manage, Comment
      can [:logout,:edit,:update], User

      if user.admin?
        can :manage, :all
      end
    end
  end
end
