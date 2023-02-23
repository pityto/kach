class Api::Admin::V1::CommonsController < Api::Admin::V1::ApiController

  def routes
    @ids = []
    list = Permission::DETAIL_API_LIST
    if list.present?
      list.each do|data|
        per = Permission.find_by(controller: data[:controller], action: data[:action])
        @ids << per.id if per.present?
      end
    end
    condition = @ids.present? ? "action = 'manage' or id in (#{@ids.join(',')})" : "action = 'manage'"
    if current_employee.admin?
      @permissions = Permission.all
    else
      role_ids = current_employee.roles.pluck(:id).join(',')
      if role_ids.present?
        @permissions = Permission.joins(:roles).where("roles.id in (#{ role_ids })")
      else
        @permissions = Permission.where(id: "")
      end
    end
    @permissions = @permissions.where(condition)
    @permissions = @permissions.group_by{ |p| p.controller[0, p.controller.rindex("/")] }
    @menus = @permissions.keys
  end

  def upload_attachment
    requires! :file, type: "File" # 待上传的附件
    requires! :attachment_entity_type, type: String # 上传对象类名称，eg:Banner:Banner，产品:Product
    requires! :attachment_entity_id, type: Integer # 上传对象id
    if params[:attachment_entity_type].to_s == "Product"
      requires! :customize_type, type: String, values: ["COA", "MSDS", "Test Report", "Product Img"] # 文件类型，当上传对象为产品时，必填，值为：数组中["COA", "MSDS", "Test Report", "Product Img"]中的一个
    end
    attachment = ::Attachment.create(attachment_params)
    Attachment.add_file_to_mongo(params[:file], attachment)
    render json: { code: 0, message: '' }, status: 200
  end

  def product_classify
    @system_setting = SystemSetting.find_by(key: "product_classify")
  end

  private
  def attachment_params
    params.permit(:attachment_entity_type, :attachment_entity_id, :customize_type)
  end
end