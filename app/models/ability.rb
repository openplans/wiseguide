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
    can :read, County

    if user.level >= 50
      ability = :manage
    else
      ability = :read
    end
    can ability, KaseRoute
    can ability, CustomerImpairment
    can ability, CustomerSupportNetworkMember
    can ability, Kase
    can ability, Customer
    can ability, Event
    can ability, Outcome
    can ability, ResponseSet
    can ability, Survey

    unless user.is_admin
      cannot :destroy, Kase
      cannot :destroy, Customer
      cannot :destroy, Event
      cannot :destroy, Outcome
      cannot :destroy, ResponseSet
      cannot :destroy, Survey
    end

    #users can only read the cases of others
    can :read, Contact
    can :manage, Contact, :user_id == user.id

    #and admins are admins
    if user.is_admin
      can :manage, :all
    end
  end
end
