class Api::Web::V1::ApiController < ActionController::API

  helper ApplicationHelper
  include ActionView::Layouts
  include ActionController::Helpers
  include ActionController::Caching

  layout 'api'

  before_action :setup_layout_elements

  class ParameterDecryptFail < ActionController::ParameterMissing
    def initialize(param)
      @param = param
      super(param)
    end
  end

  class ParameterDecodeFail < ActionController::ParameterMissing
    def initialize(param)
      @param = param
      super(param)
    end
  end

  class ParameterValueNotAllowed < ActionController::ParameterMissing
    attr_reader :values
    def initialize(param, values)
      @param = param
      @values = values
      super("#{param}的值只允许在#{values}以内")
    end
  end

  class RequestInvalid < ActionController::ParameterMissing
    def initialize(param)
      @param = param
      super
    end
  end

  class AccessDenied < StandardError; end
  class PageNotFound < StandardError; end
  class UserIsDisabled < StandardError; end
  class CustomlizeError < StandardError; end

  rescue_from(ActionController::ParameterMissing) do |err|
    render json: { code: 20001, error: 'ParameterInvalid', message: "参数#{err.param}未提供或为空" }, status: 200
  end
  rescue_from(ActiveRecord::RecordInvalid) do |err|
    render json: { code: 20002, error: 'RecordInvalid', message: err }, status: 200
  end
  rescue_from(ActiveRecord::RecordNotFound) do
    render json: { code: 20003, error: 'ResourceNotFound', message: '记录未找到' }, status: 200
  end
  rescue_from(ParameterDecryptFail) do |err|
    render json: { code: 20004, error: 'ParameterDecryptFail', message: "参数#{err.param}解密失败" }, status: 200
  end
  rescue_from(ParameterDecodeFail) do |err|
    render json: { code: 20005, error: 'ParameterDecodeFail', message: "参数#{err.param}解码失败" }, status: 200
  end
  rescue_from ::CanCan::AccessDenied do |exception|
    render json: { code: 40001, error: 'AccessDenied', message: "没有权限访问此页面" }, status: 200
  end
  rescue_from(RequestInvalid) do |err|
    render json: { code: 50000, error: 'RequestInvalid', message: "#{err.param}无效" }, status: 200
  end
  rescue_from(CustomlizeError) do |err|
    render json: { code: 50000, error: 'RequestInvalid', message: err }, status: 200
  end

  def client_ip
    result = request.headers["X-Forwarded-For"]&.split(',')&.first
    result = request.remote_ip if result.blank?
    result = '127.0.0.1' if result == "::1" && Rails.env == 'development'
    result
  end

  def client_ip_region
    Ipnet.find_by_ip(client_ip)
  end

  # 设置必选参数
  def requires!(name, opts = {})
    opts[:require] = true
    optional!(name, opts)
  end

  def optional!(name, opts = {})
    if params[name].blank? && opts[:require] == true
      raise ActionController::ParameterMissing.new(name)
    end

    if opts[:hash_key].blank? && opts[:values] && params[name].present?
      values = opts[:values].to_a
      if !values.include?(params[name]) && !values.include?(params[name].to_i)
        raise ParameterValueNotAllowed.new("name", opts[:values])
      end
    end

    if params[name].blank? && opts[:default].present?
      params[name] = opts[:default]
    end

    if opts[:hash_key] && params[name].present? && params[name].class.name == "Array"
      params[name].each_with_index do|data, index|
        data = data[opts[:hash_key]]
        tip = "#{name}[#{index}].#{opts[:hash_key]}"
        if data.blank? && opts[:require] == true
          raise ActionController::ParameterMissing.new(tip)
        end

        if opts[:values]
          values = opts[:values].to_a
          if !values.include?(data) && !values.include?(data.to_i)
            raise ParameterValueNotAllowed.new(tip, opts[:values])
          end
        end
      end
    end

  end

  # 设置成功消息
  def set_message(msg)
    @message = msg
  end

  # 返回错误信息
  def error!(msg, code)
    json = { code: code, message: msg }
    render json: json
  end

  # 显示详细错误信息
  def error_detail!(obj, code = nil)
    code ||= 20006
    message = obj.errors.messages.first
    if message.present?
      if message.count > 1
        @message = message.first.to_s + message.last.first
      else
        @message = message
      end
    else
      @message = '请求失败'
    end
    json = { code: code, message: @message }
    render json: json
  end

  def param_page
    params[:page] || 1
  end

  def param_limit
    result = params[:limit] || 10
    result = 50 if result.to_i > 50
    result
  end

  def api_t(key)
    I18n.t("api.#{key}")
  end

  def setup_layout_elements
    @code = 0
    @message = nil
  end

end
