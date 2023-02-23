json.selected_permission_ids @selected_permission_ids
json.permissions @permissions do|controller, permissions|
  json.menu I18n.t("permissions.menu.#{controller[0, controller.rindex("/")].gsub("/",'.')}")
  json.child_menu I18n.t("permissions.controller.#{controller.gsub("/",'.')}")
  json.details permissions do|per|
    json.id per.id
    json.operate_name per.get_operate_name
  end
end
