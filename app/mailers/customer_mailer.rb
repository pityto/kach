class CustomerMailer < ApplicationMailer

  def quotation_email(inquiry_quotations)
    @inquiry_quotations = inquiry_quotations
    @inquiry = @inquiry_quotations.first.inquiry
    employee_emails = []
    @inquiry_quotations.each {|v| employee_emails << v.inquiry.employee&.email}
    employee_emails = employee_emails.compact.uniq
    to_mail = [@inquiry.email] | employee_emails
    mail(to: to_mail, subject: 'Thanks for Quote')
  end

  def order_confirm_email(customer_order)
    @customer_order = customer_order
    @inquiry_quotations = @customer_order.inquiry_quotations
    @inquiry = @inquiry_quotations.first.inquiry
    to_mail = [@inquiry.email, @customer_order.employee.email]
    mail(to: to_mail, subject: 'Order Confirm')
  end
end