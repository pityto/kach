class Api::Admin::V1::Inquiry::InquiryQuotationsController < Api::Admin::V1::ApiController
  before_action :set_inquiry, only: [:show]
  include Api::Admin::V1::Inquiry::Inquiry::Quotation

  def index
    optional! :q, type: String # 产品名称或cas号
    optional! :inquiry_no, type: String # 询盘编号
    optional! :company_name, type: String # 客户公司名称
    optional! :status, type: String # 询盘状态，0-未报价，1-已发送报价，2-已完成，3-已放弃，4-采购已报价
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @inquiries = ::Inquiry
    @inquiries = @inquiries.where("inquiry_no like '#{params[:inquiry_no]}%'") if params[:inquiry_no].present?
    if params[:q].present?
      term = ActionController::Base.helpers.sanitize(params[:q].to_s.strip, tags: [])
      cas = Utils.check_cas(term.scan(/\d+-\d+-\d/).flatten.first.to_s)
      if cas.present?
        @inquiries = @inquiries.where(cas: cas)
      elsif term.present?
        term = term.gsub("'", "\\\\'") if term =~ /'/
        @inquiries = @inquiries.where("product_name like '%#{term}%'")
      end
    end
    @inquiries = @inquiries.where("company_name like '%#{params[:company_name]}%'") if params[:company_name].present?
    @inquiries = @inquiries.where(status: params[:status].to_i) if params[:status].present?
    @inquiries = @inquiries.order(created_at: :desc).page(param_page).per(param_limit)
  end

  def create_customer_order
    requires! :payment_type, type: Integer # 0-款到发货，1-预付30%货款，2-预付50%货款
    requires! :inquiry_quotation_ids, type: Array # 报价id
    requires! :invoice_type, type: Integer # 开票类型,1-增值税普通发票(13%),2-增值税普通发票(3%),3-增值税专用发票(13%),4-不开票
    requires! :ship_address, type: String # 寄送地址
    if params[:invoice_type].to_i != 4
      requires! :invoice_address, type: String # 发票寄送地址 
    end
    optional! :note, type: String # 客户备注

    inquiry_quotations = InquiryQuotation.where(id: params[:inquiry_quotation_ids])

    customers = []
    inquiry_quotations.each {|v| customers << v.inquiry.customer_id}
    error!("询盘需要先关联客户信息才能创建订单", 20007) and return if nil.in?(customers.uniq)
    error!("该询盘已成单", 20007) and return if inquiry_quotations.map(&:customer_order_id).compact.present?
    if params[:inquiry_quotation_ids].size > 1
      error!("只能勾选同一询盘的报价成单", 20007) and return if inquiry_quotations.map(&:inquiry_id).uniq.size != 1
      error!("选择多个报价成单时，确保选择报价的货币类型相同", 20007) and return if inquiry_quotations.map(&:currency_type).uniq.size != 1
    end
    inquiry_quotation = inquiry_quotations.first
    inquiry = inquiry_quotation.inquiry

    ActiveRecord::Base.transaction do
      customer_order = ::CustomerOrder.new
      # 客户信息需要先手动关联客户才能创建订单，这里自动创建的逻辑取消
      # 客户信息不存在时（通过前台下的询盘），先创建用户信息
      # if inquiry.customer_id.present?
      #   customer_order.customer_id = inquiry.customer_id
      # else
      #   custemer = Customer.create(first_name: inquiry.first_name, last_name: inquiry.last_name, phone: inquiry.phone, company_name: inquiry.company_name, email: inquiry.email)
      #   customer_order.customer_id = custemer.id
      # end
      customer_order.customer_id = inquiry.customer_id

      # 订单的创建员工为订单的负责人
      customer_order.employee_id = current_employee.id
      customer_order.currency_type = inquiry_quotation.currency_type
      customer_order.amount = inquiry_quotations.map(&:price).sum.to_d
      customer_order.payment_type = params[:payment_type].to_i
      customer_order.note = params[:note] if params[:note].present?
      customer_order.invoice_type = params[:invoice_type].to_i
      customer_order.invoice_address = params[:invoice_address] if params[:invoice_address].present?
      customer_order.ship_address = params[:ship_address]

      error_detail!(customer_order) and return if !customer_order.save
      inquiry_quotations.each do|quo|
        quo.customer_order_id = customer_order.id
        quo.save
      end
      CustomerMailer.order_confirm_email(customer_order).deliver_now
    end
    @message = '销售订单创建成功'
  end

  def show
    @inquiry_quotations = @inquiry.inquiry_quotations
  end
  
  private
  def set_inquiry
    @inquiry = ::Inquiry.find(params[:id])
  end
end