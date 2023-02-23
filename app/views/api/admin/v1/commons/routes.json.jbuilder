json.page_datas @menus do |menu|
  menu_name = I18n.t("permissions.menu.#{menu.gsub("/",'.')}")
  json.name menu_name
  json.path menu.gsub('api/admin/v1', '')
  json.meta do
    json.title menu_name
    json.icon I18n.t("permissions.icon.#{menu.gsub("/",'.')}")
  end
  json.redirect 'noRedirect'
  json.children @permissions[menu] do|per|
    per_name = I18n.t("permissions.controller.#{per.controller.gsub("/",'.')}")
    path = per.controller.split('/').last
    if per.id.in?(@ids)
      path = path + '/:id'
      json.hidden true
    end
    json.path path
    json.component per.controller.gsub('api/admin/v1', '')
    json.name per_name
    json.meta do
      json.title per_name
      json.icon "emp"
    end
  end
end