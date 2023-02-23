class Api::Admin::V1::Product::ProductsController < Api::Admin::V1::ApiController
  before_action :set_product, only: [:update, :destroy, :quotation_histories]

  def index
    optional! :cas, type: String # cas号
    optional! :name, type: String # 产品名称
    optional! :is_advantage, type: Integer # 是否优势产品，1-是，0-否
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @products = ::Product.all
    @products = @products.where("cas like '#{params[:cas]}%'") if params[:cas].present?
    @products = @products.where("name like '%#{params[:name]}%'") if params[:name].present?
    @products = @products.where(is_advantage: params[:is_advantage].to_i) if params[:is_advantage].present?
    @products = @products.page(param_page).per(param_limit)
  end

  def create
    requires! :cas, type: String # cas号
    requires! :name, type: String # 产品名称
    optional! :catalog_no, type: String # 目录号
    optional! :mf, type: String # MF
    optional! :mw, type: String # MW
    optional! :purity, type: String # 纯度
    requires! :reference_price, type: String # 参考价格
    optional! :specification, type: "Text" # 产品规格
    requires! :classify, type: String # 产品分类
    requires! :is_advantage, type: Integer # 是否优势产品，1-是，0-否
    requires! :weight, type: "Decimal" # 权重，用于排序，从大到小

    @product = ::Product.new products_params
    error_detail!(@product) and return if !@product.save
  end

  def update
    requires! :cas, type: String # cas号
    requires! :name, type: String # 产品名称
    optional! :catalog_no, type: String # 目录号
    optional! :mf, type: String # MF
    optional! :mw, type: String # MW
    optional! :purity, type: String # 纯度
    requires! :reference_price, type: String # 参考价格
    optional! :specification, type: "Text" # 产品规格
    requires! :classify, type: String # 产品分类
    requires! :is_advantage, type: Integer # 是否优势产品，1-是，0-否
    requires! :weight, type: "Decimal" # 权重，用于排序，从大到小

    error_detail!(@product) if !@product.update(products_params)
  end

  def destroy
    @product.update(is_delete: Time.now.to_i)
  end

  def quotation_histories
    @inquiry_quotations = InquiryQuotation.joins(:inquiry).where("inquiries.cas = ?", @product.cas).page(param_page).per(param_limit)
  end

  def classify
    @system_setting = SystemSetting.find_by(key: "product_classify")
  end

  def update_classify
    requires! :value, type: Array # 产品分类

    error!("value值类型必须为数组", 20001) and return if params[:value].class.name != "Array"
    @system_setting = SystemSetting.find_or_initialize_by(key: "product_classify")
    @system_setting.value = params[:value].join(",")
    @system_setting.save
  end

  def import
    requires! :file, type: File # 名称
    
    cas_ary = []
    book = Roo::Spreadsheet.open params[:file].tempfile
    sheet = book.sheet 0
    # 表头
    temple = ["cas号", "产品名称", "参考价格", "产品分类", "目录号", "MF", "MW", "纯度", "产品规格"]
    error!('模板表头错误，表头按序为cas号,产品名称,参考价格,产品分类,目录号,MF,MW,纯度,产品规格', 20007) and return if sheet.first != temple
    sheet.each_with_index do |row, index|
      next if index == 0
      product = ::Product.new
      product.cas = row[0]
      product.name = row[1]
      product.reference_price = row[2]
      product.classify = row[3]
      product.catalog_no = row[4]
      product.mf = row[5]
      product.mw = row[6]
      product.purity = row[7]
      product.specification = row[8]
      product.save
    end
    @message = "导入成功"
  end

  private
  def products_params
    params.permit(:cas, :name, :catalog_no, :mf, :mw, :purity, :reference_price, :specification, :classify, :is_advantage, :weight)
  end

  def set_product
    @product = ::Product.find(params[:id])
  end
  
end