class EmployeeService

  # 更新登录信息，并把api_token存入缓存
  # 将更新操作放入队列
  def self.update_signin_info_perform_later(employee, client_ip, ip_region)
    api_token = Utils::Gen.friendly_token
    # 存入缓存
    Employee.set_cache_api_token(employee.id, api_token)
    params = {
      employee_id: employee.id,
      api_token: api_token,
      signin_count: employee.signin_count + 1,
      current_signin_at: DateUtils.time2str(Time.now),
      current_signin_ip: client_ip,
      last_signin_at: DateUtils.time2str(employee.current_signin_at||Time.now),
      last_signin_ip: employee.current_signin_ip
    }
    # 每次都异步更新一下api_token
    UpdateEmployeeSigninInfoJob.perform_later(params)
  end

  def self.update_signin_info(params)
    employee = Employee.find_by(id: params[:employee_id])
    if employee.present?
      employee.update(
        api_token: params[:api_token],
        signin_count: params[:signin_count],
        current_signin_at: params[:current_signin_at],
        current_signin_ip: params[:current_signin_ip],
        last_signin_at: params[:last_signin_at],
        last_signin_ip: params[:last_signin_ip]
        )
    end
  end

end