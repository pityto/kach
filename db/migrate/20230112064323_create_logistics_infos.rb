class CreateLogisticsInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :logistics_infos do |t|
      t.string :num, comment: "单号"
      t.string :order_no, comment: "订单号"
      t.text :info, comment: "物流信息"
      t.integer :is_delete, default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
    add_index(:logistics_infos, :num)
  end
end
