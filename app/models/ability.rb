class Ability
  include CanCan::Ability

  def initialize(current_active_admin_user)
    current_active_admin_user ||= AdminUser.new # guest user (not logged in)
    if current_active_admin_user.role? :superadmin
        can :manage, :all
        
    elsif current_active_admin_user.role? :customeadmin
        can :manage, :all
        
    elsif current_active_admin_user.role? :subadmin
        
        #can :create, :all
        can :update  , :all # you can give right to perticular page by adding   ",Page" 
        can :read, :all
    else
       can :read, :all
    end
  end
end