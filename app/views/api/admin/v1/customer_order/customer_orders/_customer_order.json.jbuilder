json.id customer_order.id
json.order_no customer_order.order_no
json.invoice_type customer_order.invoice_type
json.amount customer_order.amount
json.currency_type customer_order.currency_type
json.received_amount customer_order.received_amount
json.received_at format_standard_time(customer_order.received_at)
json.order_status customer_order.order_status
json.payment_type customer_order.payment_type
json.payment_status customer_order.payment_status
json.note customer_order.note
json.ship_address customer_order.ship_address
json.invoice_address customer_order.invoice_address
json.created_at format_standard_time(customer_order.created_at)
quotation = customer_order.inquiry_quotations.first
inquiry = quotation.inquiry
json.incoterms quotation.incoterms
json.product_id inquiry.product_id
json.cas inquiry.cas
json.product_name inquiry.product_name
json.package inquiry.package
json.purity inquiry.purity