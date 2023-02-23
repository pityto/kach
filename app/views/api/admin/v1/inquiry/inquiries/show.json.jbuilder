json.partial! 'api/admin/v1/inquiry/inquiries/inquiry', inquiry: @inquiry
json.inquiry_quotations @inquiry_quotations do |quotation|
  json.partial! 'api/admin/v1/inquiry/inquiries/inquiry_quotation', quotation: quotation
end