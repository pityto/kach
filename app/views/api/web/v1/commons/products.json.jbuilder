json.page_datas @products do |product|
  json.id product.id
  json.cas product.cas
  json.name product.name
  json.product_img_url product.attachments&.find_by(customize_type: "Product Img")&.get_file_path.to_s
end
json.partial! "api/shared/page", items: @products