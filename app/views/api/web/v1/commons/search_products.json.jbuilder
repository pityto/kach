json.page_datas @results do |re|
  json.id re.id
  json.cas re.cas
  json.name re.name
  json.catalog_no re.catalog_no
  json.classify re.classify
end
json.partial! "api/shared/page", items: @results