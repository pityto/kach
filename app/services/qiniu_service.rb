class QiniuService

  def self.init
    # 要上传的空间
    @bucket = CONFIG.qiniu_bucket_name
  end
  
  # 上传本地文件
  # @param file_path [String] Object的名字
  # @param local_file_path [String] 上传文件的本地路径
  def self.upload_file(file_path, local_file_path)
    init
    # 构建上传策略，上传策略的更多参数请参照 http://developer.qiniu.com/article/developer/security/put-policy.html
    put_policy = Qiniu::Auth::PutPolicy.new(
      @bucket, # 存储空间
      file_path,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
      3600    # token 过期时间，默认为 3600 秒，即 1 小时
    )
    # 生成上传 Token
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    # 调用 upload_with_token_2 方法上传
    code, result, response_headers = Qiniu::Storage.upload_with_token_2(
      uptoken,
      local_file_path,
      file_path,
      nil, # 可以接受一个 Hash 作为自定义变量，请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#xvar
      bucket: @bucket
    )
    render_result(code, result, response_headers)
  end

  def self.get_sts_info
    init
    # 构建上传策略，上传策略的更多参数请参照 http://developer.qiniu.com/article/developer/security/put-policy.html
    put_policy = Qiniu::Auth::PutPolicy.new(
      @bucket, # 存储空间
      nil,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
      600    # token 过期时间，单位：秒
    )
    # 生成上传 Token
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    {bucket_name: @bucket, token: uptoken, upload_url: CONFIG.qiniu_upload_url}
  end

  # 删除单个文件
  # @param file_path [String] Object的名字
  def self.delete_file(file_path='my-ruby-logo.png')
    init
    code, result, response_headers = Qiniu::Storage.delete(
      @bucket,
      file_path
    )
    render_result(code, result, response_headers)
  end

  def self.get_download_url(file_path)
    CONFIG.qiniu_preview_url + "/" + file_path
  end
  
  def self.render_result(code, result, response_headers)
    if code == 200
      success = true
    else
      success = false
    end
    [success, code, result.to_s]
  end

end