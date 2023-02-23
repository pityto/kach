class CreateIntroductions < ActiveRecord::Migration[6.1]
  def change
    create_table :introductions do |t|
      t.string :name, comment: "公司名称"
      t.string :address, comment: "地址"
      t.string :tel, comment: "电话"
      t.string :fax, comment: "传真"
      t.string :email, comment: "email"
      t.integer :is_delete, default: 0, comment: "删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
  end
end
