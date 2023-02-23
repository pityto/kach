json.page_datas @customers do |customer|
  json.id customer.id
  json.first_name customer.first_name
  json.last_name customer.last_name
  json.company_name customer.company_name
  json.email customer.email
  json.phone customer.phone
  json.created_at format_standard_time(customer.created_at)
end
json.partial! "api/shared/page", items: @customers