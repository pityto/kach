class CustomerMailerPreview < ActionMailer::Preview

  def quotation_email
    # 邮件模板预览地址
    # http://localhost:3000/rails/mailers/customer_mailer/quotation_email
    CustomerMailer.quotation_email(InquiryQuotation.where(id: [7,10]))
  end

  def order_confirm_email
    # 邮件模板预览地址
    # http://localhost:3000/rails/mailers/customer_mailer/order_confirm_email
    CustomerMailer.order_confirm_email(CustomerOrder.first)
  end
end