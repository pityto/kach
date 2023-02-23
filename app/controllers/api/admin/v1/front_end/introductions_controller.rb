class Api::Admin::V1::FrontEnd::IntroductionsController < Api::Admin::V1::ApiController
  before_action :set_introduction, only: [:update, :destroy]

  def index
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @introductions = Introduction.all
    @introductions = @introductions.page(param_page).per(param_limit)
  end

  def create
    requires! :name, type: String # 公司名称
    requires! :address, type: String # 地址
    requires! :tel, type: String # 电话
    requires! :fax, type: String # 传真
    requires! :email, type: String # email

    @introduction = Introduction.new introductions_params
    error_detail!(@introduction) and return if !@introduction.save
  end

  def update
    requires! :name, type: String # 公司名称
    requires! :address, type: String # 地址
    requires! :tel, type: String # 电话
    requires! :fax, type: String # 传真
    requires! :email, type: String # email

    error_detail!(@introduction) if !@introduction.update(introductions_params)
  end

  def destroy
    @introduction.update(is_delete: Time.now.to_i)
  end

  def company_introduction
    @system_setting = SystemSetting.find_by(key: "company_introduction")
  end

  def update_company_introduction
    requires! :value, type: "String" # 简介信息

    @system_setting = SystemSetting.find_or_initialize_by(key: "company_introduction")
    @system_setting.value = params[:value]
    @system_setting.save
  end

  private
  def introductions_params
    params.permit(:name, :address, :tel, :fax, :email)
  end

  def set_introduction
    @introduction = Introduction.find(params[:id])
  end
  
end