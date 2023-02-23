class Api::Admin::V1::ApiController < ActionController::API

  helper ApplicationHelper
  include ActionView::Layouts
  include ActionController::Helpers
  include ActionController::Caching

  layout 'api'
  helper_method :current_employee, :encrypt_string

  before_action :setup_layout_elements
  before_action :authenticate_employee!, :check_permissions

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
  rescue_from(ActiveRecord::RecordNotFound) do |err|
    render json: { code: 20003, error: 'ResourceNotFound', message: "记录未找到(#{err})" }, status: 200
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


  def current_employee
    @current_employee
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
        raise ParameterValueNotAllowed.new(name, opts[:values])
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

  # 创建API访问Token
  def create_jwt(employee)
    payload = { id: employee.id, username: employee.username}
    api_token = Employee.get_cache_api_token(employee.id)
    JWT.encode(payload, api_token)
  end

  def encrypt_string(text, key=CONFIG.client_api_secret_key)
    Utils::AesEncrypt.encrypt(text, key)
  end

  # 根据headers认证用户
  def authenticate_employee!
    auth_jwt!
    rescue JWT::ExpiredSignature
      error!('令牌过期', 10003)
    rescue JWT::VerificationError
      error!('当前账号异常，请重新登录', 10001)
    rescue JWT::DecodeError
      error!('令牌非法', 10004)
    rescue JWT::InvalidIssuerError
      error!(e, 10005)
    rescue UserIsDisabled
      error!(api_t("employee_has_been_disabled"), 10002)
  end

  def auth_jwt!
    jwt = request.headers['HTTP_AUTHORIZATION']&.split(' ')&.last
    raise JWT::VerificationError.new if jwt.blank?

    # 读取令牌携带用户信息，此处不作令牌的验证，因为密钥要从用户信息里取，不会抛出异常
    payload, header = JWT.decode(jwt, nil, false, verify_expiration: true)

    employee = Employee.find(payload['id'])
    raise(UserIsDisabled) if employee.blank?

    # 获取验证令牌的密钥
    secret_key = employee ? Employee.get_cache_api_token(employee.id) : ''
    # 用秘钥验证令牌，会抛出 JWT::ExpiredSignature 或 JWT::DecodeError 异常
    payload, header = JWT.decode(jwt, secret_key)

    raise(UserIsDisabled) if !employee.is_enabled?
    # 验证成功，设置当前用户
    @current_employee = employee
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_employee)
  end

  def check_permissions
    return if action_name.in?(Permission::SKIP_AUTH_ACTION_LIST)
    auth_controller_name = ::Service::PermissionUtils.convert_controller_name(controller_path)
    if ::Service::PermissionUtils.need_check_permission(auth_controller_name)
      auth_action_name = ::Service::PermissionUtils.convert_action_name(action_name)
      authorize! auth_action_name.to_sym, auth_controller_name
    end
  end

  def append_info_to_log(tagged, message)
    message = "controller_name:#{controller_path},action:#{action_name},message:#{message}"
    Rails.logger.tagged(tagged) { Rails.logger.info(message) }
  end
end
