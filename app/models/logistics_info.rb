class LogisticsInfo < ApplicationRecord
  default_scope -> {where(is_delete: 0)}
  serialize :info
end