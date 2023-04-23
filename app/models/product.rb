class Product < ApplicationRecord
  default_scope -> {where(is_delete: 0)}
  before_create :auto_check_fields
  
  has_many :attachments, ->{order(created_at: :desc)}, as: :attachment_entity

  def auto_check_fields
    self.cas = self.cas.strip
  end
end