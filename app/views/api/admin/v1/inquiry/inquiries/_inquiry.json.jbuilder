json.id inquiry.id
json.inquiry_no inquiry.inquiry_no
json.customer_id inquiry.customer_id
json.first_name inquiry.first_name
json.last_name inquiry.last_name
json.phone inquiry.phone
json.company_name inquiry.company_name
json.email inquiry.email
json.product_id inquiry.product_id
json.cas inquiry.cas
json.product_name inquiry.product_name
json.package inquiry.package
json.purity inquiry.purity
json.status inquiry.status
json.send_quotation_at format_standard_time(inquiry.send_quotation_at)
json.note inquiry.note.to_s
json.source inquiry.source
json.employee_id inquiry.employee_id
json.employee_name inquiry.employee&.name

json.inquiry_quotations inquiry.inquiry_quotations do |quotation|
  json.partial! 'api/admin/v1/inquiry/inquiries/inquiry_quotation', quotation: quotation
end