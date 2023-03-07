# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_07_055047) do

  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "customer_id"
    t.string "name", comment: "姓名"
    t.string "mobile", comment: "联系方式"
    t.string "country", limit: 100, comment: "国家"
    t.string "province", limit: 100, comment: "省份"
    t.string "city", limit: 100, comment: "城市"
    t.string "district", limit: 100, comment: "地区"
    t.string "address", comment: "地址"
    t.boolean "is_default", default: false, comment: "是否默认地址"
    t.integer "is_delete", default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_addresses_on_customer_id"
  end

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "attachment_entity_type", limit: 64
    t.integer "attachment_entity_id"
    t.string "path", comment: "文件路径"
    t.string "name", comment: "文件名"
    t.string "content_type", comment: "文件类型"
    t.integer "file_size", comment: "文件大小"
    t.string "customize_type", comment: "自定义类型"
    t.integer "is_delete", default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachment_entity_type", "attachment_entity_id"], name: "attachments_entity_index"
  end

  create_table "banners", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", comment: "标题"
    t.string "subtitle", comment: "副标题"
    t.decimal "weight", precision: 10, scale: 2, default: "50.0", comment: "权重，用于排序"
    t.boolean "is_display", default: true, comment: "是否显示，1-是，0-否"
    t.integer "is_delete", default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customer_orders", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "customer_id", comment: "客户id"
    t.integer "employee_id", comment: "业务员id"
    t.string "order_no", limit: 32
    t.integer "invoice_type", default: 4, comment: "发票类型,1-增值税普通发票(13%),2-增值税普通发票(3%),3-增值税专用发票(13%),4-不开票"
    t.decimal "shipping_fee", precision: 10, scale: 2, default: "0.0", comment: "运费"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", comment: "应付总额"
    t.decimal "received_amount", precision: 10, scale: 2, default: "0.0", comment: "实际收款金额"
    t.datetime "received_at", comment: "收款时间"
    t.integer "order_status", default: 1, comment: "0-未确认，1-已确认，2-部分发货，3-完全发货，4-订单完成，5-取消"
    t.integer "payment_type", default: 0, comment: "0-款到发货，1-预付30%货款，2-预付50%货款"
    t.integer "payment_status", default: 0, comment: "支付状态：0:未付款  1: 已付款  2: 部分付款"
    t.integer "currency_type", default: 1, comment: "客户货币类型:1-CNY,2-USD,3-INR,4-EUR"
    t.decimal "exchange_rate", precision: 10, scale: 2, default: "1.0", comment: "客户货币类型对人民币的汇率"
    t.string "note", comment: "客户备注"
    t.string "ship_address", limit: 512, comment: "寄送地址"
    t.string "invoice_address", limit: 512, comment: "发票寄送地址"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_customer_orders_on_created_at"
    t.index ["customer_id"], name: "index_customer_orders_on_customer_id"
    t.index ["employee_id"], name: "index_customer_orders_on_employee_id"
    t.index ["order_no"], name: "index_customer_orders_on_order_no"
  end

  create_table "customers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "first_name", comment: "first_name"
    t.string "last_name", comment: "last_name"
    t.string "phone", comment: "手机号"
    t.string "company_name", comment: "公司名称"
    t.string "email", comment: "email"
    t.integer "is_delete", default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "employee_id", comment: "负责员工id"
    t.string "country", comment: "国家"
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", comment: "员工表", force: :cascade do |t|
    t.string "username", default: "", null: false, comment: "账号"
    t.string "password_digest", default: "", null: false, comment: "密码"
    t.string "api_token", default: "", comment: "应用API TOKEN"
    t.string "name", limit: 20, comment: "名字"
    t.integer "position_id", default: 0, null: false, comment: "职位,0-其它,1-销售,2-采购"
    t.integer "job_status", default: 1, null: false, comment: "在职状态, 1:在职, -1:离职"
    t.date "joined_on", comment: "入职日期"
    t.string "mobile", limit: 30, comment: "手机"
    t.string "office_tel", limit: 30, comment: "公司电话"
    t.string "qq_num", comment: "qq号"
    t.date "birthday", comment: "生日"
    t.boolean "is_enabled", default: true, comment: "是否启用，1-是，0-否"
    t.datetime "current_signin_at", comment: "当前登录时间"
    t.string "current_signin_ip", default: "", comment: "当前登录ip"
    t.datetime "last_signin_at", comment: "上次登录时间  "
    t.string "last_signin_ip", default: "", comment: "上次登录ip"
    t.integer "signin_count", default: 0, comment: "登录次数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", comment: "email"
    t.index ["username"], name: "index_employees_on_username", unique: true
  end

  create_table "employees_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "role_id"
    t.index ["employee_id", "role_id"], name: "index_employees_roles_on_employee_id_and_role_id"
    t.index ["employee_id"], name: "index_employees_roles_on_employee_id"
    t.index ["role_id"], name: "index_employees_roles_on_role_id"
  end

  create_table "inquiries", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "inquiry_no", limit: 40, comment: "询盘编号"
    t.integer "employee_id", comment: "业务员id"
    t.integer "customer_id"
    t.string "first_name", comment: "客户的first_name"
    t.string "last_name", comment: "客户的last_name"
    t.string "phone", comment: "客户的手机号"
    t.string "company_name", comment: "客户的公司名称"
    t.string "email", comment: "客户的email"
    t.integer "product_id"
    t.string "cas"
    t.string "product_name"
    t.string "package", comment: "包装，eg:100g"
    t.string "purity", default: "", comment: "纯度"
    t.integer "status", default: 0, comment: "0-未报价，1-已报价，2-已完成，3-已放弃"
    t.datetime "send_quotation_at", comment: "报价时间"
    t.string "note", comment: "客户备注"
    t.integer "source", default: 0, comment: "询盘来源，0-后台录入，1-前台"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cas"], name: "index_inquiries_on_cas"
    t.index ["created_at"], name: "index_inquiries_on_created_at"
    t.index ["product_id"], name: "index_inquiries_on_product_id"
    t.index ["status"], name: "index_inquiries_on_status"
  end

  create_table "inquiry_quotations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "vendor_company_name", comment: "供应商名称"
    t.integer "inquiry_id"
    t.string "quotation_no", limit: 40, comment: "询盘报价编号"
    t.integer "customer_order_id"
    t.string "package", comment: "包装，eg:100g"
    t.string "purity", default: "", comment: "纯度"
    t.string "appear_light", limit: 32, comment: "产品亮度"
    t.string "appear_shape", limit: 32, comment: "产品形状"
    t.string "appear_color", limit: 32, comment: "产品颜色"
    t.decimal "price", precision: 12, scale: 2, default: "0.0", comment: "不开票价"
    t.decimal "price_invoice", precision: 12, scale: 2, default: "0.0", comment: "开票价"
    t.integer "currency_type", default: 2, comment: "客户价(price)对应的货币类型:1-CNY,2-USD,3-INR,4-EUR"
    t.string "stock", comment: "货期"
    t.string "note", limit: 512, comment: "报价备注"
    t.integer "active", default: 1, comment: "是否有效，1-有效，0-无效"
    t.integer "status", default: 0, comment: "是否已发送报价, 0-未发送，1-已发送"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "cost_price", precision: 12, scale: 2, default: "0.0", comment: "成本价"
    t.integer "cp_currency_type", default: 1, comment: "成本价对应的货币类型:1-CNY,2-USD,3-INR,4-EUR"
    t.string "purchase_note", comment: "采购报价备注"
    t.decimal "exchange_rate", precision: 12, scale: 2, comment: "成本价换算客户价时货币间的汇率"
    t.string "incoterms", comment: "报价贸易术语"
    t.string "transport_mode", comment: "运输方式，by Courier/by Sea/by Express"
    t.decimal "profit", precision: 12, scale: 2, default: "0.0", comment: "利润"
    t.decimal "shipping_fee", precision: 12, scale: 2, default: "0.0", comment: "运费"
    t.decimal "operating_fee", precision: 12, scale: 2, default: "0.0", comment: "操作费"
    t.string "testing_project", comment: "检测项目"
    t.decimal "testing_fee", precision: 12, scale: 2, default: "0.0", comment: "检测费"
    t.boolean "is_declare", default: true, comment: "，是否报关"
    t.decimal "declare_fee", precision: 12, scale: 2, default: "0.0", comment: "报关费"
    t.string "appraisal_project", comment: "鉴定项目"
    t.decimal "appraisal_fee", precision: 12, scale: 2, default: "0.0", comment: "鉴定费"
    t.decimal "bank_fee", precision: 12, scale: 2, default: "5.0", comment: "银行手续费"
    t.boolean "is_dangerous", default: false, comment: "是否危险品"
    t.string "storage", comment: "存储条件，常温/2-8度/-20度"
    t.boolean "is_take_charge", default: false, comment: "是否监管"
    t.string "hs_code", comment: "hs_code"
    t.string "country", comment: "原产国"
    t.boolean "is_customized", default: false, comment: "是否定制，1-定制，0-现货"
    t.index ["customer_order_id"], name: "index_inquiry_quotations_on_customer_order_id"
    t.index ["inquiry_id"], name: "index_inquiry_quotations_on_inquiry_id"
  end

  create_table "introductions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", comment: "公司名称"
    t.string "address", comment: "地址"
    t.string "tel", comment: "电话"
    t.string "fax", comment: "传真"
    t.string "email", comment: "email"
    t.integer "is_delete", default: 0, comment: "删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoices", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "customer_id"
    t.string "company_name", comment: "开发票的公司名称"
    t.string "tax_no", comment: "税务号"
    t.string "mobile", comment: "电话"
    t.string "fax", comment: "传真"
    t.string "company_address", comment: "公司地址"
    t.string "bank", comment: "银行"
    t.string "account_no", comment: "账号"
    t.boolean "is_default", default: false, comment: "是否默认发票地址"
    t.string "delivery_address", limit: 1024, comment: "发票收货地址"
    t.string "delivery_country", comment: "收货国家"
    t.string "delivery_contact", comment: "收货人"
    t.string "delivery_mobile", comment: "收货人电话"
    t.string "delivery_email", comment: "收货人邮箱"
    t.integer "category", default: 1, comment: "发票类型,1-增值税普通发票(13%),2-增值税普通发票(3%),3-增值税专用发票(13%),4-不开票"
    t.integer "active", default: 1, comment: "是否有效，1-有效，0-无效"
    t.integer "is_delete", default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "leave_words", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "first_name", comment: "first_name"
    t.string "last_name", comment: "last_name"
    t.string "phone", comment: "手机号"
    t.string "company_name", comment: "公司名称"
    t.string "email", comment: "email"
    t.string "message", comment: "信息"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "logistics_infos", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "num", comment: "单号"
    t.string "order_no", comment: "订单号"
    t.text "info", comment: "物流信息"
    t.integer "is_delete", default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "company_name", comment: "物流公司名称"
    t.index ["num"], name: "index_logistics_infos_on_num"
  end

  create_table "permissions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "controller", comment: "控制器名称"
    t.string "action", comment: "方法名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "cas", limit: 32, comment: "cas号"
    t.string "name", comment: "产品名称"
    t.string "catalog_no", comment: "目录号"
    t.string "mf", comment: "MF"
    t.string "mw", comment: "MW"
    t.string "purity", comment: "纯度"
    t.string "reference_price", comment: "参考价格"
    t.text "specification", comment: "产品规格"
    t.string "classify", comment: "产品分类"
    t.integer "is_advantage", default: 0, comment: "是否优势产品，1-是，0-否"
    t.decimal "weight", precision: 10, scale: 2, default: "50.0", comment: "权重，用于排序"
    t.integer "is_delete", default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cas"], name: "index_products_on_cas"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", comment: "角色名称"
    t.string "name_cn", comment: "中文名"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "roles_permissions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "permission_id"
    t.index ["permission_id"], name: "index_roles_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_roles_permissions_on_role_id_and_permission_id"
    t.index ["role_id"], name: "index_roles_permissions_on_role_id"
  end

  create_table "system_settings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.string "description"
    t.boolean "is_enabled", default: true
    t.integer "is_delete", default: 0, comment: "删除字段，删除后更新为删除时间的时间戳"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
