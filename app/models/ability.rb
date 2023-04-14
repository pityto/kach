class Ability
  include CanCan::Ability

  def initialize(employee)
    cannot :manage, :all if employee.blank?
    if employee.present?
      can :manage, :all if employee&.admin?
      employee.roles.includes(:permissions).each do |role|
        role.permissions.each do |permission|
          can permission.action.to_sym, permission.controller
        end
      end
    end
  end

end
