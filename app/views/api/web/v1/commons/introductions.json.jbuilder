json.introductions @company_introduction
json.page_datas @introductions do |introduction|
  json.id introduction.id
  json.name introduction.name
  json.address introduction.address
  json.tel introduction.tel
  json.fax introduction.fax
  json.email introduction.email
end
json.partial! "api/shared/page", items: @introductions


