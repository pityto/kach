class Api::Admin::V1::FrontEnd::LogisticsInfosController < Api::Admin::V1::ApiController
  before_action :set_logistics_info, only: [:update, :destroy]

  def index
    optional! :num, type: String # 物流单号
    optional! :order_no, type: String # 订单号
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @logistics_infos = LogisticsInfo.all
    @logistics_infos = @logistics_infos.where("num like '%#{params[:num]}%'") if params[:num].present?
    @logistics_infos = @logistics_infos.where("order_no like '%#{params[:order_no]}%'") if params[:order_no].present?
    @logistics_infos = @logistics_infos.page(param_page).per(param_limit)
  end

  def create
    requires! :num, type: String # 物流单号
    requires! :info, type: String # 物流信息
    requires! :order_no, type: String # 订单号
    requires! :company_name, type: String # 物流公司名称

    @logistics_info = LogisticsInfo.new logistics_info_params
    error_detail!(@logistics_info) and return if !@logistics_info.save
  end

  def update
    requires! :num, type: String # 物流单号
    requires! :info, type: String # 物流信息
    requires! :order_no, type: String # 订单号
    requires! :company_name, type: String # 物流公司名称

    error_detail!(@logistics_info) if !@logistics_info.update(logistics_info_params)
  end

  def destroy
    @logistics_info.update(is_delete: Time.now.to_i)
  end

  private
  def logistics_info_params
    params.permit(:num, :order_no, :company_name, info: [[:time, :info, :sort]])
  end

  def set_logistics_info
    @logistics_info = LogisticsInfo.find(params[:id])
  end
  
end