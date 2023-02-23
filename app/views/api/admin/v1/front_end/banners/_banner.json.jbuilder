json.id banner.id
json.title banner.title
json.subtitle banner.subtitle
json.weight banner.weight
json.is_display banner.is_display ? 1 : 0
json.img_url banner.attachment&.get_file_path.to_s