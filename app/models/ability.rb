class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read,:search,:tab],Idea
    can [:login,:new,:create],User
    if user
      can [:promotion,:new,:create,:like,:unlike], Idea
      can :manage, Comment
      can :logout, User

      if user.admin?
        can :manage, :all
      end
    end
  end
end
