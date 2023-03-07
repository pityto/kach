json.page_datas @invoices do |invoice|
  json.partial! 'api/admin/v1/crm/customers/invoice', invoice: invoice
end
json.partial! "api/shared/page", items: @invoices