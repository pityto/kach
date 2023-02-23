class Customer < ApplicationRecord
  default_scope -> {where(is_delete: 0)}
  
end