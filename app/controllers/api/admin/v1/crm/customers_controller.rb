class Api::Admin::V1::Crm::CustomersController < Api::Admin::V1::ApiController
  before_action :set_customer, only: [:update, :destroy]

  def index
    optional! :first_name, type: String # first_name
    optional! :last_name, type: String # last_name
    optional! :phone, type: String # phone
    optional! :company_name, type: String # company_name
    optional! :email, type: String # email
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @customers = Customer.all
    @customers = @customers.where("first_name like '%#{params[:first_name]}%'") if params[:first_name].present?
    @customers = @customers.where("last_name like '%#{params[:last_name]}%'") if params[:last_name].present?
    @customers = @customers.where("phone like '%#{params[:phone]}%'") if params[:phone].present?
    @customers = @customers.where("company_name like '%#{params[:company_name]}%'") if params[:company_name].present?
    @customers = @customers.where("email like '%#{params[:email]}%'") if params[:email].present?
    @customers = @customers.page(param_page).per(param_limit)
  end

  def create
    requires! :first_name, type: String # first_name
    requires! :last_name, type: String # last_name
    requires! :phone, type: String # 手机号
    requires! :company_name, type: String # 公司名称
    requires! :email, type: String # email

    @customer = Customer.new customer_params
    error_detail!(@customer) and return if !@customer.save
  end

  def update
    requires! :first_name, type: String # first_name
    requires! :last_name, type: String # last_name
    requires! :phone, type: String # 手机号
    requires! :company_name, type: String # 公司名称
    requires! :email, type: String # email

    error_detail!(@customer) if !@customer.update(customer_params)
  end

  def destroy
    @customer.update(is_delete: Time.now.to_i)
  end

  private
  def customer_params
    params.permit(:first_name, :last_name, :phone, :company_name, :email)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end
end