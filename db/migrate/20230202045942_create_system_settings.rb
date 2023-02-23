class CreateSystemSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :system_settings do |t|
      t.string :key
      t.text :value
      t.string :description
      t.boolean :is_enabled, default: true
      t.integer :is_delete, default: 0, comment: "删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
  end
end
