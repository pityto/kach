class CreateCustomerOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_orders do |t|
      t.integer :customer_id, comment: "客户id"
      t.integer :employee_id, comment: "业务员id"
      t.string :order_no, limit: 32
      t.integer :invoice_type, default: 4, comment: "发票类型,1-增值税普通发票(13%),2-增值税普通发票(3%),3-增值税专用发票(13%),4-不开票"
      t.decimal :shipping_fee, precision: 10, scale: 2, default: "0.0", comment: "运费"
      t.decimal :amount, precision: 10, scale: 2, default: "0.0", comment: "应付总额"
      t.decimal :received_amount, precision: 10, scale: 2, default: "0.0", comment: "实际收款金额"
      t.datetime :received_at, comment: "收款时间"
      t.integer :order_status, default: 1, comment: "0-未确认，1-已确认，2-部分发货，3-完全发货，4-订单完成，5-取消"
      t.integer :payment_type, default: 0, comment: "0-款到发货，1-预付30%货款，2-预付50%货款"
      t.integer :payment_status, default: 0, comment: "支付状态：0:未付款  1: 已付款  2: 部分付款"
      t.integer :currency_type, default: 1, comment: "客户货币类型:1-CNY,2-USD,3-INR,4-EUR"
      t.decimal :exchange_rate, precision: 10, scale: 2, default: "1.0", comment: "客户货币类型对人民币的汇率"
      t.string :note, comment: "客户备注"
      t.string :ship_address, limit: 512, comment: "寄送地址"
      t.string :invoice_address, limit: 512, comment: "发票寄送地址"
      t.timestamps
    end
    add_index(:customer_orders, :customer_id)
    add_index(:customer_orders, :created_at)
    add_index(:customer_orders, :employee_id)
    add_index(:customer_orders, :order_no)
  end
end
