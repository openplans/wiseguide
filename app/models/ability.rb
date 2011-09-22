class Ability
  include CanCan::Ability

  def initialize(user)

    if user.level < 0
      return #turned-off users can do nothing
    end

    #system tables
    can :read, Disposition
    can :read, Ethnicity
    can :read, EventType
    can :read, FundingSource
    can :read, Impairment
    can :read, ReferralType
    can :read, Route
    can :read, TripReason
    can :read, User

    if user.level >= 50
      ability = :manage
    else
      ability = :read
    end
    can ability, KaseRoute
    can ability, CustomerImpairment
    can ability, CustomerSupportNetworkMember

    if user.level >= 0
      ability = [:create, :read, :update] 
    else
      ability = :read
    end
    can ability, Kase
    can ability, Customer
    can ability, Event
    can ability, Outcome
    can ability, ResponseSet
    can ability, Survey

    #users can only read the cases of others
    can :read, Contact
    can :manage, Contact, :user_id == user.id

    #and admins are admins
    if user.is_admin
      can :manage, :all
    end
  end
end
