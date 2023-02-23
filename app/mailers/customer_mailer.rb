class CustomerMailer < ApplicationMailer

  def quotation_email(inquiry_quotations)
    @inquiry_quotations = inquiry_quotations
    @inquiry = @inquiry_quotations.first.inquiry
    to_mail = ["347637161@qq.com", "zsh347637161@gmail.com"]
    mail(to: to_mail, subject: 'Thanks for Quote')
  end

  def order_confirm_email(customer_order)
    @customer_order = customer_order
    @inquiry_quotations = @customer_order.inquiry_quotations
    @inquiry = @inquiry_quotations.first.inquiry
    mail(to: "347637161@qq.com", subject: 'Order Confirm')
  end
end