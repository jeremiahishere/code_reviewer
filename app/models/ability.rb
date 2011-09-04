class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new
    # basic user can't do anything except view the home page and sign in

    if user.has_role?(:coder)
      # can only see their own projects
      can [:create, :read, :update, :destroy], [Project, Review]
      can [:add_submission, :review_submission, :close], Review
      can :vote, ReviewVote
      can :add_comment, Comment
    end

    if user.has_role?(:manager)
      # can see all projects
      can :manage, [Project, Review, ReviewVote, Comment]
      # cannot see users
    end

    if user.has_role?(:admin)
      # can see everything on the site
      # including user setup
      can :manage, :all
    end
  end
end
