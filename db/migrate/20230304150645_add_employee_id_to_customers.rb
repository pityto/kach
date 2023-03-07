class AddEmployeeIdToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :employee_id, :integer, comment: "负责员工id"
  end
end
