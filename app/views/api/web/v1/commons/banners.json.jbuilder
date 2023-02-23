json.page_datas @banners do |banner|
  json.id banner.id
  json.title banner.title
  json.subtitle banner.subtitle
  json.weight banner.weight
  json.img_url banner.attachment&.get_file_path.to_s
end
json.partial! "api/shared/page", items: @banners

