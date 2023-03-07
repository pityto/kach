json.page_datas @addresses do |address|
  json.partial! 'api/admin/v1/crm/customers/address', address: address
end
json.partial! "api/shared/page", items: @addresses