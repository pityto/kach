class Customer < ApplicationRecord
  has_many :addresses
  has_many :invoices
  belongs_to :employee
  default_scope -> {where(is_delete: 0)}
  
end