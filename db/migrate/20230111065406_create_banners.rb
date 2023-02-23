class CreateBanners < ActiveRecord::Migration[6.1]
  def change
    create_table :banners do |t|
      t.string :title, comment: "标题"
      t.string :subtitle, comment: "副标题"
      t.decimal :weight, precision: 10, scale: 2, default: "50.0", comment: "权重，用于排序"
      t.boolean :is_display, default: true, comment: "是否显示，1-是，0-否"
      t.integer :is_delete, default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
  end
end
