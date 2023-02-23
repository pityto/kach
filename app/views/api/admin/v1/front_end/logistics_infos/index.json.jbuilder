json.page_datas @logistics_infos do |logistics_info|
  json.partial! 'api/admin/v1/front_end/logistics_infos/logistics_info', logistics_info: logistics_info
end
json.partial! "api/shared/page", items: @logistics_infos