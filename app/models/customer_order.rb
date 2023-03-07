class CustomerOrder < ApplicationRecord
  belongs_to :employee
  belongs_to :customer
  has_many :inquiry_quotations
  before_create :auto_create_fields
  validates :received_amount, numericality: {less_than_or_equal_to: :amount, message: "收款金额不能大于订单金额"}


  def auto_create_fields
    self.order_no = self.get_order_no
  end

  def get_order_no
    # 年月日 + 创建时间的毫秒数值 + 3位随机数
    "KC#{Time.new.strftime("%y%m%d")}#{DateTime.current.strftime('%Q')[9..12]}#{get_random(3)}"
  end

  def get_random(len, chars=[])
    chars = ("0".."9").to_a if chars.blank?
    result = []
    len.times { |i| result << chars[rand(chars.size-1)] }
    result.join('')
  end
end