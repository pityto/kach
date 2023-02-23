json.page_datas @results do |re|
  json.id re.id
  json.cas re.cas
  json.name re.name
  json.catalog_no re.catalog_no
  json.mf re.mf
  json.mw re.mw
  json.purity re.purity
  json.reference_price re.reference_price
  json.specification re.specification
  json.classify re.classify
  json.is_advantage re.is_advantage ? 1 : 0
  json.weight re.weight
end
json.partial! "api/shared/page", items: @results