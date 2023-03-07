class Address < ApplicationRecord
  default_scope -> {where(is_delete: 0)}
  belongs_to :customer
  
  def get_detail_address
    province.to_s + city.to_s + district.to_s + address.to_s + "，收货人：" + name.to_s + "，电话：" + mobile.to_s
  end
end