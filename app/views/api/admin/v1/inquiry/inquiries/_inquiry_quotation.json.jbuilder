json.inquiry_id quotation.inquiry_id
json.inquiry_quotation_id quotation.id
json.vendor_company_name quotation.vendor_company_name
json.price quotation.price.to_f
json.package quotation.package
json.purity quotation.purity
json.appear_shape quotation.appear_shape
json.purchase_note quotation.purchase_note
json.note quotation.note
json.created_at format_standard_time(quotation.created_at)

json.cost_price quotation.cost_price.to_f
json.exchange_rate quotation.get_exchange_rate
json.cost_price_usd quotation.get_cost_price_usd.to_f
json.incoterms quotation.incoterms.to_s
json.transport_mode quotation.transport_mode.to_s
json.profit quotation.profit.to_f
json.shipping_fee quotation.shipping_fee.to_f
json.operating_fee quotation.operating_fee.to_f
json.testing_project quotation.testing_project.to_s
json.testing_fee quotation.testing_fee.to_f
json.is_declare quotation.is_declare? ? 1 : 0
json.declare_fee quotation.declare_fee.to_f
json.appraisal_project quotation.appraisal_project.to_s
json.appraisal_fee quotation.appraisal_fee.to_f
json.bank_fee quotation.bank_fee.to_f
json.is_dangerous quotation.is_dangerous? ? 1 : 0
json.storage quotation.storage.to_s
json.is_take_charge quotation.is_take_charge? ? 1 : 0
json.hs_code quotation.hs_code.to_s
json.country quotation.country.to_s
json.is_customized quotation.is_customized? ? 1 : 0
json.stock quotation.stock
