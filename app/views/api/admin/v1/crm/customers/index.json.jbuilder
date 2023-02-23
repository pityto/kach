json.page_datas @customers do |customer|
  json.partial! 'api/admin/v1/crm/customers/customer', customer: customer
end
json.partial! "api/shared/page", items: @customers