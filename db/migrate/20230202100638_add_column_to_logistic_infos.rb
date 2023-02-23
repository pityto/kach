class AddColumnToLogisticInfos < ActiveRecord::Migration[6.1]
  def change
    add_column :logistics_infos, :company_name, :string, comment: "物流公司名称"
  end
end
