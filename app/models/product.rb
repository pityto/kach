class Product < ApplicationRecord
  default_scope -> {where(is_delete: 0)}
  
  has_many :attachments, ->{order(created_at: :desc)}, as: :attachment_entity
end