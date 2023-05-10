module Api
  module Admin
    module V1
      module Inquiry
        module Inquiry
          module Quotation
            
            def quotation_details
              inquiry = ::Inquiry.find(params[:id])
              @inquiry_quotations = inquiry.inquiry_quotations.page(param_page).per(param_limit)
            end
            
            # 询盘报价模块中报价为采购报价，即成本价，默认货币单位为1-CNY 人民币
            def new_quotation
              requires! :vendor_company_name, type: String # 供应商名称
              requires! :price, type: "Decimal" # 价格
              # requires! :currency_type, type: Integer, values: [1,2,3,4] # 货币类型:1-CNY,2-USD,3-INR,4-EUR
              requires! :package, type: String # 包装，eg:100g
              requires! :purity, type: String # 纯度
              optional! :stock, type: String # 货期
              optional! :note, type: String # 报价备注

              inquiry = ::Inquiry.find(params[:id])
              @quotation = inquiry.inquiry_quotations.new
              @quotation.vendor_company_name = quotation_params[:vendor_company_name]
              @quotation.cost_price = quotation_params[:price]
              @quotation.cp_currency_type = 1
              @quotation.package = quotation_params[:package]
              @quotation.purity = quotation_params[:purity]
              @quotation.stock = quotation_params[:stock] if quotation_params[:stock].present?
              @quotation.purchase_note = quotation_params[:note] if quotation_params[:note].present?
              error_detail!(@quotation) and return if !@quotation.save
              inquiry.update(status: 4) if inquiry.status == 0
            end

            def update_quotation
              requires! :inquiry_quotation_id, type: Integer # 报价id
              requires! :vendor_company_name, type: String # 供应商名称
              requires! :price, type: "Decimal" # 价格
              # requires! :currency_type, type: Integer, values: [1,2,3,4] # 货币类型:1-CNY,2-USD,3-INR,4-EUR
              requires! :package, type: String # 包装，eg:100g
              requires! :purity, type: String # 纯度
              optional! :stock, type: String # 货期
              optional! :note, type: String # 报价备注
              
              @quotation = ::InquiryQuotation.find(params[:inquiry_quotation_id])
              @quotation.vendor_company_name = quotation_params[:vendor_company_name]
              @quotation.cost_price = quotation_params[:price]
              @quotation.package = quotation_params[:package]
              @quotation.purity = quotation_params[:purity]
              @quotation.stock = quotation_params[:stock] if quotation_params[:stock].present?
              @quotation.purchase_note = quotation_params[:note] if quotation_params[:note].present?
              error_detail!(@quotation) and return if !@quotation.save
            end

            def quotation_histories
              inquiry = ::Inquiry.find(params[:id])
              @inquiry_quotations = InquiryQuotation.joins(:inquiry).where("inquiries.cas = ? and inquiries.id not in (?)", inquiry.cas, inquiry.id).distinct.page(param_page).per(param_limit)
            end

            private
            def quotation_params
              params.permit(:id, :vendor_company_name, :price, :package, :purity, :note, :stock)
            end

          end
        end
      end
    end
  end
end