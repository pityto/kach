json.page_datas @roles do |role|
  json.partial! 'api/admin/v1/hr/roles/role', role: role
end
json.partial! "api/shared/page", items: @roles