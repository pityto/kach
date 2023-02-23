class AddColumnsToInquiryQuotations < ActiveRecord::Migration[6.1]
  def change
    add_column :inquiry_quotations, :cost_price, :decimal, precision: 12, scale: 2, default: "0.0", comment: "成本价"
    add_column :inquiry_quotations, :cp_currency_type, :integer, default: 1, comment: "成本价对应的货币类型:1-CNY,2-USD,3-INR,4-EUR"
    add_column :inquiry_quotations, :purchase_note, :string, comment: "采购报价备注"
    add_column :inquiry_quotations, :exchange_rate, :decimal, precision: 12, scale: 2, comment: "成本价换算客户价时货币间的汇率"
    change_column :inquiry_quotations, :currency_type, :integer, default: 2, comment: "客户价(price)对应的货币类型:1-CNY,2-USD,3-INR,4-EUR"
    add_column :inquiry_quotations, :incoterms, :string, comment: "报价贸易术语"
    add_column :inquiry_quotations, :transport_mode, :string, comment: "运输方式，by Courier/by Sea/by Express"
    add_column :inquiry_quotations, :profit, :decimal, precision: 12, scale: 2, default: "0.0", comment: "利润"
    add_column :inquiry_quotations, :shipping_fee, :decimal, precision: 12, scale: 2, default: "0.0", comment: "运费"
    add_column :inquiry_quotations, :operating_fee, :decimal, precision: 12, scale: 2, default: "0.0", comment: "操作费"
    add_column :inquiry_quotations, :testing_project, :string, comment: "检测项目"    
    add_column :inquiry_quotations, :testing_fee, :decimal, precision: 12, scale: 2, default: "0.0", comment: "检测费"
    add_column :inquiry_quotations, :is_declare, :boolean, default: true, comment: "，是否报关"
    add_column :inquiry_quotations, :declare_fee, :decimal, precision: 12, scale: 2, default: "0.0", comment: "报关费"
    add_column :inquiry_quotations, :appraisal_project, :string, comment: "鉴定项目"    
    add_column :inquiry_quotations, :appraisal_fee, :decimal, precision: 12, scale: 2, default: "0.0", comment: "鉴定费"
    add_column :inquiry_quotations, :bank_fee, :decimal, precision: 12, scale: 2, default: "5.0", comment: "银行手续费"
    add_column :inquiry_quotations, :is_dangerous, :boolean, default: false, comment: "是否危险品"
    add_column :inquiry_quotations, :storage, :string, comment: "存储条件，常温/2-8度/-20度"
    add_column :inquiry_quotations, :is_take_charge, :boolean, default: false, comment: "是否监管"
    add_column :inquiry_quotations, :hs_code, :string, comment: "hs_code"
    add_column :inquiry_quotations, :country, :string, comment: "原产国"
    add_column :inquiry_quotations, :is_customized, :boolean, default: false, comment: "是否定制，1-定制，0-现货"
  end
end
