class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :cas, limit: 32, comment: "cas号"
      t.string :name, comment: "产品名称"
      t.string :catalog_no, comment: "目录号"
      t.string :mf, comment: "MF"
      t.string :mw, comment: "MW"
      t.string :purity, comment: "纯度"
      t.string :reference_price, comment: "参考价格"
      t.text :specification, comment: "产品规格"
      t.string :classify, comment: "产品分类"
      t.integer :is_advantage, default: 0, comment: "是否优势产品，1-是，0-否"
      t.decimal :weight, precision: 10, scale: 2, default: "50.0", comment: "权重，用于排序"
      t.integer :is_delete, default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
    add_index(:products, :cas)
  end
end
