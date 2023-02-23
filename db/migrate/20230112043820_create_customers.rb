class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :first_name, comment: "first_name"
      t.string :last_name, comment: "last_name"
      t.string :phone, comment: "手机号"
      t.string :company_name, comment: "公司名称"
      t.string :email, comment: "email"
      t.integer :is_delete, default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
  end
end
