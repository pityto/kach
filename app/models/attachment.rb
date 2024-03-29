class Attachment < ApplicationRecord
  belongs_to :attachment_entity, polymorphic: true

  default_scope -> {where(is_delete: 0)}
  
  # 添加内容到缓存
  def self.add_file_to_mongo(file, obj=nil)
    grid = Rails.mongo.database.fs
    begin
      file_name = file.original_filename.gsub(' ', '')
      store_dir = "aclconf/#{file_name}"
      grid.upload_from_stream(store_dir, file, content_type: file.content_type)
      if obj.blank?
        obj = self.create(name: file_name, content_type: file.content_type, file_size: file.size, path: store_dir)
      else
        obj.update(name: file_name, content_type: file.content_type, file_size: file.size, path: store_dir)
      end
      return [true, obj]
    rescue => e
      return [false, e]
    end
  end

  # 获取web访问地址
  def get_file_path
    mongo_config = CONFIG.mongo.to_hash
    "#{mongo_config[:download_host]}/#{mongo_config[:database]}/#{self.path}"
  end

  # 直接mongodb获取文件流
  def find_url_file
    grid_file = Rails.mongo.database.fs.find_one(:filename => self.path)
    # 返回文件流
    grid_file.data
  end

end
