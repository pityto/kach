class Api::Admin::V1::Hr::RolesController < Api::Admin::V1::ApiController

  before_action :set_role, only: [:update, :permission, :update_permission, :employee]

  def index
    optional! :name, type: String # 角色名称
    optional! :name_cn, type: String # 中文名
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @roles = Role.all
    @roles = @roles.where("name like '%#{ params[:name] }%'") if params[:name].present?
    @roles = @roles.where("name_cn like '%#{ params[:name_cn] }%'") if params[:name_cn].present?
    @roles = @roles.page(param_page).per(param_limit)
  end

  def create
    requires! :name, type: String # 角色名称
    requires! :name_cn, type: String # 中文名

    @role = Role.new role_params
    error_detail!(@role) and return if !@role.save
  end

  def update
    requires! :name, type: String # 角色名称
    requires! :name_cn, type: String # 中文名
    
    error_detail!(@role) if !@role.update(role_params)
  end

  def employee
    @employees = @role.employees
  end

  def permission
    @permissions = Permission.all
    @menus = @permissions.group_by{ |p| p.controller[0, p.controller.rindex("/")] }.keys
    @permissions = @permissions.group_by{ |p| p.controller }
    @selected_permission_ids = @role.permissions.order(:id).pluck(:id)
  end

  def update_permission
    requires! :permission_ids, type: Array # 勾选的权限id

    old_permission_ids = RolePermission.where(role_id: @role.id).pluck(:permission_id)

    new_permission_ids = params[:permission_ids].present? ? params[:permission_ids].map { |new_permission_id| new_permission_id.to_i } : []
    # 添加以前没有的权限
    add_permission_ids = new_permission_ids - old_permission_ids
    add_permission_ids.each do |permission_id|
      RolePermission.create(role_id: @role.id, permission_id: permission_id)
    end
    # 删除现在没有的权限
    delete_permission_ids = old_permission_ids - new_permission_ids
    RolePermission.where(role_id: @role.id, permission_id: delete_permission_ids).destroy_all if delete_permission_ids.present?
  end

  private
  def role_params
    params.permit(:name, :name_cn)
  end

  def set_role
    @role = Role.find(params[:id])
  end

end