json.page_datas @banners do |banner|
  json.partial! 'api/admin/v1/front_end/banners/banner', banner: banner
end
json.partial! "api/shared/page", items: @banners