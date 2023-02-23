class Api::Admin::V1::FrontEnd::BannersController < Api::Admin::V1::ApiController
  before_action :set_banner, only: [:update, :destroy]

  def index
    optional! :title, type: String # 标题
    optional! :subtitle, type: String # 副标题
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @banners = Banner.all
    @banners = @banners.where("title like '%#{params[:title]}%'") if params[:title].present?
    @banners = @banners.where("subtitle like '%#{params[:subtitle]}%'") if params[:subtitle].present?
    @banners = @banners.order(created_at: :desc).page(param_page).per(param_limit)
  end

  def create
    requires! :title, type: String # 标题
    requires! :subtitle, type: String # 副标题
    requires! :weight, type: "Decimal" # 权重，用于排序，从小到大
    requires! :is_display, type: Integer # 是否显示，1-是，0-否

    @banner = Banner.new banners_params
    error_detail!(@banner) and return if !@banner.save
  end

  def update
    requires! :title, type: String # 标题
    requires! :subtitle, type: String # 副标题
    requires! :weight, type: "Decimal" # 权重，用于排序，从大到小
    requires! :is_display, type: Integer # 是否显示，1-是，0-否

    error_detail!(@banner) if !@banner.update(banners_params)
  end

  def destroy
    @banner.update(is_delete: Time.now.to_i)
  end

  private
  def banners_params
    params.permit(:title, :subtitle, :weight, :is_display)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end
  
end