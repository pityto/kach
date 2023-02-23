json.page_datas @employees do |employee|
  json.partial! 'api/admin/v1/hr/employees/employee', employee: employee
end
json.partial! "api/shared/page", items: @employees