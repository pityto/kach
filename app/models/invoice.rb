class Invoice < ApplicationRecord
  default_scope -> {where(is_delete: 0)}
  belongs_to :customer
  
end