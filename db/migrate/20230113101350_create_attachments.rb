class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.string :attachment_entity_type, limit: 64
      t.integer :attachment_entity_id
      t.string :path, comment: "文件路径"
      t.string :name, comment: "文件名"
      t.string :content_type, comment: "文件类型"
      t.integer :file_size, comment: "文件大小"
      t.string :customize_type, comment: "自定义类型"
      t.integer :is_delete, default: 0, comment: "软删除字段，删除后更新为删除时间的时间戳"
      t.timestamps
    end
    add_index :attachments, [:attachment_entity_type, :attachment_entity_id], name: 'attachments_entity_index'
  end
end
