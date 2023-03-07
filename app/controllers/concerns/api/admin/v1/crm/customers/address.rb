module Api
  module Admin
    module V1
      module Crm
        module Customers
          module Address
            
            def addresses
              @addresses = @customer.addresses.page(param_page).per(param_limit)
            end

            def new_address
              requires! :name, type: String # 姓名
              requires! :mobile, type: String # 联系方式
              optional! :province, type: String # 省份
              optional! :city, type: String # 城市
              optional! :district, type: String # 地区
              requires! :address, type: String # 地址
              requires! :is_default, type: String # 是否默认地址，1-是，0-否

              @address = ::Address.new address_params.except(:id, :address_id).merge(customer_id: @customer.id)
              error_detail!(@address) and return if !@address.save
            end

            def update_address
              requires! :address_id, type: Integer # 收货地址id
              requires! :name, type: String # 姓名
              requires! :mobile, type: String # 联系方式
              optional! :province, type: String # 省份
              optional! :city, type: String # 城市
              optional! :district, type: String # 地区
              requires! :address, type: String # 地址
              requires! :is_default, type: String # 是否默认地址，1-是，0-否
              
              @address = ::Address.find(address_params[:address_id])
              error_detail!(@address) if !@address.update(address_params.except(:id, :address_id))
            end

            def delete_address
              requires! :address_id, type: Integer # 收货地址id

              @address = ::Address.find(address_params[:address_id])
              @address.update(is_delete: Time.now.to_i)
            end

            private
            def address_params
              params.permit(:id, :name, :mobile, :province, :city, :district, :address, :is_default, :address_id)
            end

          end
        end
      end
    end
  end
end