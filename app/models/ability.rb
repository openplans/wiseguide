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
    can :read, Survey

    if user.level >= 50
      ability = :manage
    else
      ability = :read
    end

    can ability, Kase
    can ability, KaseRoute
    can ability, Customer
    can ability, CustomerImpairment
    can ability, Event
    can ability, Outcome
    can ability, ResponseSet, :kase=>{:user_id=>user.id}

    #users can only read their own cases
    can :read, Contact
    can :manage, Contact, :user_id == user.id

    #and admins are admins
    if user.is_admin
      can :manage, :all
    end

  end
end
