json.page_datas @products do |product|
  json.partial! 'api/admin/v1/product/advantage_products/product', product: product
end
json.partial! "api/shared/page", items: @products