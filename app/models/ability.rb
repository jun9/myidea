class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read,:search,:tab],Idea
    if user
      can [:promotion,:new,:create,:like,:unlike,:favoriate,:unfavoriate,:preview], Idea
      can :manage, Comment

      if user.admin?
        can :manage, :all
      end
    end
  end
end
