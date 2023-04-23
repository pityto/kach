class Api::Web::V1::CommonsController < Api::Web::V1::ApiController

  def logistics_info
    requires! :num, type: String # 物流单号
    
    @logistics_info = LogisticsInfo.find_by("num like '%#{params[:num]}%'")
  end

  def inquiries
    requires! :cas, type: String # CAS号
    optional! :package, type: String # 包装，eg:100g
    optional! :purity, type: String # 纯度
    optional! :note, type: String # 客户需求说明
    optional! :company_name, type: String # 客户公司名称
    optional! :first_name, type: String # 联系人名称
    requires! :phone, type: String # 电话
    requires! :email, type: String # 邮箱
  
    product = Product.find_by(cas: params[:cas])
    @inquiry = ::Inquiry.new(package: params[:package], purity: params[:purity], note: params[:note], company_name: params[:company_name], first_name: params[:first_name], phone: params[:phone], email: params[:email], source: 1)
    @inquiry.cas =  params[:cas]
    if product.present?
      @inquiry.product_id = product.id
      @inquiry.product_name = product.name
    end
    error_detail!(@inquiry) and return if !@inquiry.save
  end

  def leave_words
    requires! :first_name, type: String # first_name
    requires! :last_name, type: String # last_name
    requires! :phone, type: String # 电话号码
    requires! :company_name, type: String # 公司名称
    requires! :email, type: String # 邮箱
    requires! :message, type: String # 留言内容
  
    @leave_word = ::LeaveWord.new(first_name: params[:first_name], last_name: params[:last_name], phone: params[:phone], company_name: params[:company_name], email: params[:email], message: params[:message])
    error_detail!(@leave_word) and return if !@leave_word.save
  end

  def products
    optional! :is_advantage, type: Integer # 是否优势产品，1-是，0-否
    optional! :classify, type: String # 产品分类
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    optional! :q, type: String # 搜索参数，cas号或产品名称

    @products = ::Product.all

    if params[:q].present?
      @term = ActionController::Base.helpers.sanitize(params[:q].to_s.strip, tags: [])
      cas = Utils.check_cas(@term.scan(/\d+-\d+-\d/).flatten.first.to_s)
      if cas.present?
        @products = @products.where(cas: cas)
      elsif @term.present?
        @term = @term.gsub("'", "\\\\'") if @term =~ /'/
        @products = @products.where("name like '%#{@term}%'")
      end
    end
    @products = @products.where(classify: params[:classify]) if params[:classify].present?
    if params[:is_advantage].present?
      @products = @products.where(is_advantage: params[:is_advantage].to_i)
      @products = @products.order(weight: :desc)
    end
    @products = @products.page(param_page).per(param_limit)
  end

  def product_classify
    @system_setting = SystemSetting.find_by(key: "product_classify")
  end

  def product_detail
    requires! :product_id, type: String # 产品id
    
    @product = ::Product.find(params[:product_id])
  end

  def banners
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数

    @banners = ::Banner.where(is_display: true).order(weight: :desc)
    @banners = @banners.page(param_page).per(param_limit)    
  end

  def introductions
    @introductions = ::Introduction.all
    system_setting = SystemSetting.find_by(key: "company_introduction")
    @company_introduction = system_setting.present? ? system_setting.value : ""
  end
  
  def search_products
    requires! :q, type: String # 搜索参数，cas号或产品名称
    
    @results = nil
    @term = ActionController::Base.helpers.sanitize(params[:q].to_s.strip, tags: [])
    cas = Utils.check_cas(@term.scan(/\d+-\d+-\d/).flatten.first.to_s)
    if cas.present?
      @results = ::Product.where(cas: cas).page(param_page).per(param_limit)
    elsif @term.present?
      @results = ::Product.where("name like '%#{@term}%'").page(param_page).per(param_limit)
    end
  end
end