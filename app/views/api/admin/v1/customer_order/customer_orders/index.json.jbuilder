json.page_datas @customer_orders do |customer_order|
  json.partial! 'api/admin/v1/customer_order/customer_orders/customer_order', customer_order: customer_order
end
json.partial! "api/shared/page", items: @customer_orders