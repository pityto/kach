class CreateInquries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.string :inquiry_no, limit: 40, comment: "询盘编号"
      t.integer :employee_id, comment: "业务员id"
      t.integer :customer_id
      t.string :first_name, comment: "客户的first_name"
      t.string :last_name, comment: "客户的last_name"
      t.string :phone, comment: "客户的手机号"
      t.string :company_name, comment: "客户的公司名称"
      t.string :email, comment: "客户的email"
      t.integer :product_id
      t.string :cas
      t.string :product_name
      t.string :package, comment: "包装，eg:100g"
      t.string :purity, default: "", comment: "纯度"
      t.integer :status, default: 0, comment: "0-未报价，1-已报价，2-已完成，3-已放弃"
      t.datetime :send_quotation_at, comment: "报价时间"
      t.string :note, comment: "客户备注"
      t.integer "source", default: 0, comment: "询盘来源，0-后台录入，1-前台"
      t.timestamps
    end
    add_index(:inquiries, :cas)
    add_index(:inquiries, :created_at)
    add_index(:inquiries, :product_id)
    add_index(:inquiries, :status)

    create_table :inquiry_quotations do |t|
      t.string :vendor_company_name, comment: "供应商名称"
      t.integer :inquiry_id
      t.string :quotation_no, limit: 40, comment: "询盘报价编号"
      t.integer :customer_order_id
      t.string :package, comment: "包装，eg:100g"
      t.string :purity, default: "", comment: "纯度"
      t.string :appear_light, limit: 32, comment: "产品亮度"
      t.string :appear_shape, limit: 32, comment: "产品形状"
      t.string :appear_color, limit: 32, comment: "产品颜色"
      t.decimal :price, precision: 12, scale: 2, default: "0.0", comment: "不开票价"
      t.decimal :price_invoice, precision: 12, scale: 2, default: "0.0", comment: "开票价"
      t.integer :currency_type, default: 1, comment: "货币类型:1-CNY,2-USD,3-INR,4-EUR"
      t.string :stock, comment: "货期"
      t.string :note, limit: 512, comment: "报价备注"
      t.integer :active, default: 1, comment: "是否有效，1-有效，0-无效"
      t.integer :status, default: 0, comment: "是否已发送报价, 0-未发送，1-已发送"
      t.timestamps
    end
    add_index(:inquiry_quotations, :customer_order_id)
    add_index(:inquiry_quotations, :inquiry_id)
  end
end

