class CreateSomeTables < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.integer :customer_id
      t.string :company_name, comment: "开发票的公司名称"
      t.string :tax_no, comment: "税务号"
      t.string :mobile, comment: "电话"
      t.string :fax, comment: "传真"
      t.string :company_address, comment: "公司地址"
      t.string :bank, comment: "银行"
      t.string :account_no, comment: "账号"
      t.boolean :is_default, default: false, comment: "是否默认发票地址"
      t.string :delivery_address, limit: 1024, comment: "发票收货地址"
      t.string :delivery_country, comment: "收货国家"
      t.string :delivery_contact, comment: "收货人"
      t.string :delivery_mobile, comment: "收货人电话"
      t.string :delivery_email, comment: "收货人邮箱"
      t.integer :category, default: 1, comment: "发票类型,1-增值税普通发票(13%),2-增值税普通发票(3%),3-增值税专用发票(13%),4-不开票"
      t.integer :active, default: 1, comment: "是否有效，1-有效，0-无效"
      t.integer :is_delete, default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
    add_index(:invoices, :customer_id)


    create_table :addresses do |t|
      t.integer :customer_id
      t.string :name, comment: "姓名"
      t.string :mobile, comment: "联系方式"
      t.string :country, limit: 100, comment: "国家"
      t.string :province, limit: 100, comment: "省份"
      t.string :city, limit: 100, comment: "城市"
      t.string :district, limit: 100, comment: "地区"
      t.string :address, comment: "地址"
      t.boolean :is_default, default: false, comment: "是否默认地址"
      t.integer :is_delete, default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
    add_index(:addresses, :customer_id)
    add_column :employees, :email, :string, comment: "email"
  end
end
