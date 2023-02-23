class Role < ApplicationRecord
  has_and_belongs_to_many :employees, :join_table => :employees_roles
  has_and_belongs_to_many :permissions, join_table: :roles_permissions
  # belongs_to :resource,
  #            :polymorphic => true,
  #            :optional => true

  # validates :resource_type,
  #           :inclusion => { :in => Rolify.resource_types },
  #           :allow_nil => true

  # scopify


  def delete_role_it
    self.destroy
  end

  def self.employees_of_role(role_en)
    find_by(name: role_en)&.employees
  end
  def self.employees_list_of_role(role_en)
    employees_of_role(role_en)&.on_job&.map{|e| [e.name, e.id]}
  end

end
