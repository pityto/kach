class Inquiry < ApplicationRecord
  
  has_many :inquiry_quotations
  belongs_to :product
  belongs_to :customer

  before_create :auto_create_fields
  after_save :update_relation_info, if: -> { self.saved_change_to_product_id? || self.saved_change_to_customer_id?}
  
  def update_relation_info
    if self.saved_change_to_product_id? && self.product.present?
      self.cas = self.product.cas
      self.product_name = self.product.name
    end
    if self.saved_change_to_customer_id? && self.customer.present?
      self.first_name = self.customer.first_name
      self.last_name = self.customer.last_name
      self.phone = self.customer.phone
      self.company_name = self.customer.company_name
      self.email = self.customer.email
    end
    self.save
  end

  def auto_create_fields
    self.inquiry_no = self.get_inquiry_no
  end
  
  def get_inquiry_no
    # 年月日 + 购买时间的毫秒数值 + 3位随机数
    "IN#{Time.new.strftime("%y%m%d")}#{DateTime.current.strftime('%Q')[9..12]}#{get_random(3)}"
  end

  def get_random(len,chars=[])
    chars = ("0".."9").to_a if chars.blank?
    result = []
    len.times { |i| result << chars[rand(chars.size-1)] }
    result.join('')
  end

end