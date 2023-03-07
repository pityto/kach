module Api
  module Admin
    module V1
      module Crm
        module Customers
          module Invoice
            
            def invoices
              @invoices = @customer.invoices.page(param_page).per(param_limit)
            end

            def new_invoice
              requires! :company_name , type: String # 开发票的公司名称
              requires! :tax_no, type: String # 税务号
              requires! :mobile, type: String # 电话
              requires! :company_address, type: String # 公司地址
              requires! :bank, type: String # 银行
              requires! :account_no, type: String # 账号
              requires! :delivery_address, type: String # 发票收货地址
              requires! :delivery_contact, type: String # 发票收货人
              requires! :delivery_mobile, type: String # 发票收货人电话
              requires! :category, type: String # 发票类型,1-增值税普通发票(13%),2-增值税普通发票(3%),3-增值税专用发票(13%),4-不开票
              requires! :is_default, type: Integer # 是否默认地址，1-是，0-否
              requires! :active, type: Integer # 是否有效，1-有效，0-无效
              optional! :delivery_country, type: String # 发票收货国家
              optional! :delivery_email, type: String # 收货人邮箱
              optional! :fax, type: String # 传真

              @invoice = ::Invoice.new invoice_params.except(:id, :invoice_id).merge(customer_id: @customer.id)
              error_detail!(@invoice) and return if !@invoice.save
            end

            def update_invoice
              requires! :invoice_id, type: Integer # 发票信息id
              requires! :company_name , type: String # 开发票的公司名称
              requires! :tax_no, type: String # 税务号
              requires! :mobile, type: String # 电话
              requires! :company_address, type: String # 公司地址
              requires! :bank, type: String # 银行
              requires! :account_no, type: String # 账号
              requires! :delivery_address, type: String # 发票收货地址
              requires! :delivery_contact, type: String # 发票收货人
              requires! :delivery_mobile, type: String # 发票收货人电话
              requires! :category, type: String # 发票类型,1-增值税普通发票(13%),2-增值税普通发票(3%),3-增值税专用发票(13%),4-不开票
              requires! :is_default, type: Integer # 是否默认地址，1-是，0-否
              requires! :active, type: Integer # 是否有效，1-有效，0-无效
              optional! :delivery_country, type: String # 发票收货国家
              optional! :delivery_email, type: String # 收货人邮箱
              optional! :fax, type: String # 传真
              
              @invoice = ::Invoice.find(invoice_params[:invoice_id])
              error_detail!(@invoice) if !@invoice.update(invoice_params.except(:id, :invoice_id))
            end

            def delete_invoice
              requires! :invoice_id, type: Integer # 发票信息id

              @invoice = ::Invoice.find(invoice_params[:invoice_id])
              @invoice.update(is_delete: Time.now.to_i)
            end

            private
            def invoice_params
              params.permit(:id, :company_name, :tax_no, :mobile, :fax, :company_address, :bank, :account_no, :delivery_address, :delivery_country, :delivery_contact, :delivery_mobile, :delivery_email, :category, :is_default, :active, :invoice_id)
            end

          end
        end
      end
    end
  end
end