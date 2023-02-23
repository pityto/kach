class Permission < ApplicationRecord
  has_and_belongs_to_many :roles, join_table: :roles_permissions
  # 注释详情页等接口的列表值维护，前端渲染菜单的时候不需要在权限接口额外返回这部分详情页的权限
  # DETAIL_API_LIST = [{controller: 'api/admin/v1/crm/companies', action: 'show'}, {controller: 'api/admin/v1/inquiry/inquiries', action: 'show'}]
  DETAIL_API_LIST = []

  # 后台不需要验证权限的action list
  SKIP_AUTH_ACTION_LIST = ['sign_in', 'sign_out']
  def get_operate_name
    if self.action.in?(["manage", "read", "create", "destroy", "update", "show"])
      I18n.t("permissions.operate.#{ self.action }")
    else
      I18n.t("permissions.operate.#{ self.controller.gsub("/",'.') + "." + self.action }")
    end
  end
end