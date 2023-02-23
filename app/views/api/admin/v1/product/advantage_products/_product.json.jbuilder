json.id product.id
json.cas product.cas
json.name product.name
json.catalog_no product.catalog_no
json.mf product.mf
json.mw product.mw
json.purity product.purity
json.reference_price product.reference_price
json.specification product.specification
json.classify product.classify
json.is_advantage product.is_advantage ? 1 : 0
json.weight product.weight
json.product_img_url product.attachments&.find_by(customize_type: "Product Img")&.get_file_path.to_s
json.coa_url product.attachments&.find_by(customize_type: "COA")&.get_file_path.to_s
json.msds_url product.attachments&.find_by(customize_type: "MSDS")&.get_file_path.to_s
json.test_report_url product.attachments&.find_by(customize_type: "Test Report")&.get_file_path.to_s