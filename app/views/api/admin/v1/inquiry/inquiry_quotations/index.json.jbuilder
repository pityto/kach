json.page_datas @inquiries do |inquiry|
  json.partial! 'api/admin/v1/inquiry/inquiries/inquiry', inquiry: inquiry
end
json.partial! "api/shared/page", items: @inquiries