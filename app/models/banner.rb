class Banner < ApplicationRecord
  default_scope -> {where(is_delete: 0)}
  has_one :attachment, ->{order(created_at: :desc)}, as: :attachment_entity
end