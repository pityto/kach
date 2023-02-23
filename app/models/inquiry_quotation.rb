class InquiryQuotation < ApplicationRecord
  
  belongs_to :inquiry

  before_create :auto_create_fields

  def auto_create_fields
    self.quotation_no = self.get_quotation_no
  end

  def get_quotation_no
    # 年月日 + 报价时间的毫秒数值 + 3位随机数
    "QN#{Time.new.strftime("%y%m%d")}#{DateTime.current.strftime('%Q')[9..12]}#{get_random(3)}"
  end

  def get_random(len,chars=[])
    chars = ("0".."9").to_a if chars.blank?
    result = []
    len.times { |i| result << chars[rand(chars.size-1)] }
    result.join('')
  end

  def get_cost_price_usd
    exchange_rate = get_exchange_rate
    (self.cost_price.to_f/exchange_rate).ceil(2)
  end

  def get_exchange_rate
    if self.exchange_rate.present?
      self.exchange_rate
    else
      setting = SystemSetting.find_by(key: "USD_2_CNY")
      setting.present? ? setting.value.to_f : 1.0
    end
  end
end