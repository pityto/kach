class Api::Admin::V1::Inquiry::InquiriesController < Api::Admin::V1::ApiController
  before_action :set_inquiry, only: [:update, :show, :distribute_employee, :relate_customer]

  def index
    optional! :q, type: String # 产品名称或cas号
    optional! :inquiry_no, type: String # 询盘编号
    optional! :company_name, type: String # 客户公司名称
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    if current_employee.admin?
      @inquiries = ::Inquiry.all
    else
      @inquiries = ::Inquiry.where(employee_id: current_employee.id)
    end
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
    @inquiries = @inquiries.order(created_at: :desc).page(param_page).per(param_limit)
  end

  def create
    requires! :customer_id, type: Integer # 客户id
    requires! :product_id, type: Integer # 产品id
    requires! :package, type: String # 包装，eg:100g
    requires! :purity, type: String # 纯度
    optional! :note, type: String # 客户备注

    ::Product.find(params[:product_id])
    ::Customer.find(params[:customer_id])
    @inquiry = ::Inquiry.new inquiries_params
    @inquiry.employee_id = current_employee.id
    error_detail!(@inquiry) and return if !@inquiry.save
  end

  def update
    requires! :customer_id, type: Integer # 客户id
    requires! :product_id, type: Integer # 产品id
    requires! :package, type: String # 包装，eg:100g
    requires! :purity, type: String # 纯度
    optional! :note, type: String # 客户备注
    
    ::Product.find(params[:product_id])
    ::Customer.find(params[:customer_id])
    error_detail!(@inquiry) if !@inquiry.update(inquiries_params)
  end

  def show
    @inquiry_quotations = @inquiry.inquiry_quotations
  end

  def destroy
    @inquiry.update(is_delete: Time.now.to_i)
  end

  def testing_fee
    @system_setting = SystemSetting.find_by(key: "testing_fee")
  end

  def update_testing_fee
    requires! :value, type: "Decimal" # 检测费

    error!("value值类型必须为数组", 20001) and return if params[:value].class.name != "Array"
    @system_setting = SystemSetting.find_or_initialize_by(key: "testing_fee")

    permit_params = params.permit(value: ["testing_project", "testing_fee"])
    @system_setting.value = permit_params.to_h[:value].to_a
    @system_setting.save
  end

  def appraisal_fee
    @system_setting = SystemSetting.find_by(key: "appraisal_fee")
  end

  def update_appraisal_fee
    requires! :value, type: "Decimal" # 运输报告鉴定费

    error!("value值类型必须为数组", 20001) and return if params[:value].class.name != "Array"
    @system_setting = SystemSetting.find_or_initialize_by(key: "appraisal_fee")
    permit_params = params.permit(value: ["appraisal_project", "appraisal_fee"])
    @system_setting.value = permit_params.to_h[:value].to_a
    @system_setting.save
  end

  def exchange_rate
    @system_setting = SystemSetting.find_by(key: "USD_2_CNY")
  end

  def update_exchange_rate
    requires! :value, type: "Decimal" # 汇率

    @system_setting = SystemSetting.find_or_initialize_by(key: "USD_2_CNY")
    @system_setting.value = params[:value].to_d
    @system_setting.save
  end

  def update_quotation
    requires! :inquiry_quotation_id, type: String # 询盘报价id
    optional! :appear_shape, type: String # 产品性状
    optional! :note, type: String # 给客户的备注
    requires! :price, type: "Decimal" # 给客户的报价(即total_price)
    optional! :incoterms, type: String # 报价贸易术语
    optional! :transport_mode, type: String # 运输方式
    optional! :profit, type: "Decimal" # 利润
    optional! :shipping_fee, type: "Decimal" # 运费
    optional! :operating_fee, type: "Decimal" # 操作费
    optional! :testing_project, type: String # 检测项目
    optional! :testing_fee, type: "Decimal" # 检测费
    optional! :is_declare, type: Integer # 是否报关，1-是，0-否
    optional! :declare_fee, type: "Decimal" # 报关费
    optional! :appraisal_project, type: String # 鉴定项目
    optional! :appraisal_fee, type: "Decimal" # 鉴定费
    optional! :bank_fee, type: "Decimal" # 银行手续费
    optional! :is_dangerous, type: Integer # 是否危险品，1-是，0-否
    optional! :storage, type: String # 存储条件，常温/2-8度/-20度
    optional! :is_take_charge, type: Integer # 监管条件，1-有，0-无
    optional! :hs_code, type: String # hs_code
    optional! :country, type: String # 原产国
    optional! :is_customized, type: Integer # 是否定制，1-定制，0-现货
    optional! :stock, type: String # 货期
    
    @quotation = ::InquiryQuotation.find(params[:inquiry_quotation_id])
    cost_price_usd = @quotation.get_cost_price_usd
    total_price = cost_price_usd + params[:profit].to_f + params[:shipping_fee].to_f + params[:operating_fee].to_f + params[:testing_fee].to_f + params[:declare_fee].to_f + params[:appraisal_fee].to_f + params[:bank_fee].to_f
    error!("成本费与其他相关费用相加值和price参数值不符", 20007) and return if params[:price].to_f != total_price
    quo_params = inquiry_quotation_params
    quo_params[:exchange_rate] = @quotation.get_exchange_rate
    error_detail!(@quotation) if !@quotation.update(quo_params)
  end

  def send_quotation
    requires! :inquiry_quotation_ids, type: Array # 报价id数组
    
    inquiry_quotations = InquiryQuotation.where(id: params[:inquiry_quotation_ids])

    customers = []
    inquiry_quotations.each {|v| customers << v.inquiry.customer_id}
    error!("询盘需要先关联客户信息才能发送报价", 20007) and return if nil.in?(customers.uniq)
    error!("只能选择相同客户的询盘信息才能发送报价", 20007) and return if customers.uniq.count > 1
    
    inquiry_quotations.each do|iq|
      next if iq.inquiry.status == 1
      iq.update(status: 1)
      iq.inquiry.update(status: 1)
    end
    CustomerMailer.quotation_email(inquiry_quotations).deliver_now
  end

  def distribute_employee
    requires! :employee_id, type: Integer # 员工id

    error!("只有管理员才能分配客询盘订单负责人", 20007) and return if !current_employee.admin?
    @inquiry.update(employee_id: params[:employee_id].to_i)
  end

  def relate_customer
    requires! :customer_id, type: Integer # 客户id

    error!("只有前台用户下的询盘订单可以关联客户", 20007) and return if @inquiry.source == 0
    @inquiry.update(customer_id: params[:customer_id].to_i)
  end

  private
  def inquiries_params
    params.permit(:customer_id, :first_name, :last_name, :phone, :company_name, :email, :product_id, :package, :purity, :note)
  end

  def inquiry_quotation_params
    params.permit(:appear_shape, :note, :price, :incoterms, :transport_mode, :profit, :shipping_fee, :operating_fee, :testing_project, :testing_fee, :is_declare, :declare_fee, :appraisal_project, :appraisal_fee, :bank_fee, :is_dangerous, :storage, :is_take_charge, :hs_code, :country, :is_customized, :stock)
  end

  def set_inquiry
    @inquiry = ::Inquiry.find(params[:id])
  end
  
end