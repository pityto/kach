json.page_datas @inquiry_quotations do |quotation|
  json.partial! 'api/admin/v1/inquiry/inquiry_quotations/inquiry_quotation', quotation: quotation
end
json.partial! "api/shared/page", items: @inquiry_quotations