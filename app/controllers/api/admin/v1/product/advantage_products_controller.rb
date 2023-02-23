class Api::Admin::V1::Product::AdvantageProductsController < Api::Admin::V1::ApiController
  before_action :set_product, only: [:update, :destroy]

  def index
    optional! :cas, type: String # cas号
    optional! :name, type: String # 产品名称
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @products = ::Product.where(is_advantage: 1)
    @products = @products.where("cas like '#{params[:cas]}%'") if params[:cas].present?
    @products = @products.where("name like '%#{params[:name]}%'") if params[:name].present?
    @products = @products.order(weight: :desc).page(param_page).per(param_limit)
  end

  def create
    requires! :product_id, type: Integer # 产品id
    optional! :weight, type: "Decimal" # 权重，用于排序，从大到小，默认值为50

    @product = ::Product.find(params[:product_id])
    @product.is_advantage = 1
    @product.weight = params[:weight].to_d if params[:weight].present?
    @product.save
  end

  def update
    requires! :weight, type: "Decimal" # 权重，用于排序，从大到小，默认值为50

    error!("该产品不是优势产品", 20007) and return if @product.is_advantage != 1
    @product.update(weight: params[:weight].to_d)
  end

  def destroy
    @product.update(is_advantage: 0)
  end

  private
  def set_product
    @product = ::Product.find(params[:id])
  end
  
end