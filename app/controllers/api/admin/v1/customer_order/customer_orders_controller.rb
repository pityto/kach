class Api::Admin::V1::CustomerOrder::CustomerOrdersController < Api::Admin::V1::ApiController
  before_action :set_customer_order, only: [:received_amount]

  def index
    optional! :product_id, type: Integer # 产品id
    optional! :customer_id, type: Integer # 客户id
    optional! :cas, type: String # 产品cas号
    optional! :protuct_name, type: String # 产品名称
    optional! :created_start_at, type: String # 创建时间起
    optional! :created_end_at, type: String # 创建时间止
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    if current_employee.admin?
      @customer_orders = ::CustomerOrder.all
    else
      @customer_orders = ::CustomerOrder.where(employee_id: current_employee.id)
    end
    @customer_orders = @customer_orders.joins(inquiry_quotations: :inquiry).where("inquiries.product_id = ?", params[:product_id]) if params[:product_id].present?
    @customer_orders = @customer_orders.where(customer_id: params[:customer_id]) if params[:customer_id].present?
    @customer_orders = @customer_orders.joins(inquiry_quotation: :inquiry).where("inquiries.cas like '#{params[:cas]}%'") if params[:cas].present?
    @customer_orders = @customer_orders.joins(inquiry_quotation: :inquiry).where("inquiries.protuct_name like '%#{params[:protuct_name]}%'") if params[:protuct_name].present?
    @customer_orders = @customer_orders.where("customer_orders.created_at >= ?", params[:created_start_at]) if params[:created_start_at].present?
    @customer_orders = @customer_orders.where("customer_orders.created_at <= ?", params[:created_end_at].to_date.at_end_of_day) if params[:created_end_at].present?
    @customer_orders = @customer_orders.page(param_page).per(param_limit)
  end
    
  def received_amount
    requires! :received_amount, type: "Decimal" # 实际收款金额
    optional! :received_at, type: String # 收款时间
    
    @customer_order.received_amount = params[:received_amount].to_d
    @customer_order.received_at = params[:received_at] if params[:received_at].present?
    error_detail!(@customer_order) and return if !@customer_order.save
  end

  private
  def set_customer_order
    @customer_order = ::CustomerOrder.find(params[:id])
  end
end
