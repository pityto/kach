class Api::Admin::V1::Hr::EmployeesController < Api::Admin::V1::ApiController

  skip_before_action :authenticate_employee!, only: [:sign_in]
  before_action :set_employee, only: [:update, :role, :update_role]

  def index
    optional! :name, type: String # 名字
    optional! :username, type: String # 账号
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @employees = Employee.all
    @employees = @employees.where(position_id: params[:position_id]) if params[:position_id].present?
    @employees = @employees.where("name like '%#{params[:name]}%'") if params[:name].present?
    @employees = @employees.where("username like '%#{params[:username]}%'") if params[:username].present?
    @employees = @employees.order(created_at: :desc).page(param_page).per(param_limit)
  end

  def create
    requires! :username, type: String # 账号
    requires! :password, type: String # 密码
    requires! :password_confirmation, type: String # 验证密码
    requires! :name, type: String # 名字
    requires! :job_status, type: Integer # 在职状态, 1:在职, -1:离职
    requires! :position_id, type: Integer # 职位,0-其它,1-销售,2-采购
    requires! :is_enabled, type: Integer # 是否启用，1-是，0-否
    optional! :joined_on, type: String # 入职时间
    optional! :mobile, type: String # 手机号码
    optional! :office_tel, type: String # 公司电话
    optional! :qq_num, type: String # qq号
    optional! :birthday, type: String # 生日

    @employee = Employee.new employee_params
    error_detail!(@employee) and return if !@employee.save
  end

  def update
    requires! :name, type: String # 名字
    requires! :job_status, type: Integer # 在职状态, 1:在职, -1:离职
    requires! :position_id, type: Integer # 职位,0-其它,1-销售,2-采购
    requires! :is_enabled, type: Integer # 是否启用，1-是，0-否
    optional! :joined_on, type: String # 入职时间
    optional! :mobile, type: String # 手机号码
    optional! :office_tel, type: String # 公司电话
    optional! :qq_num, type: String # qq号
    optional! :birthday, type: String # 生日
    optional! :password, type: String # 密码
    optional! :password_confirmation, type: String # 验证密码

    error_detail!(@employee) if !@employee.update(employee_params)
  end

  def role
    @selected_role_ids = @employee.roles.order(:id).pluck(:id)
    @roles = Role.all
  end

  def update_role
    requires! :role_ids, type: Array # 勾选的角色id

    old_role_ids = @employee.roles.pluck(:id)
    new_role_ids = params[:role_ids].present? ? params[:role_ids].map { |role_id| role_id.to_i } : []
    # 添加以前没有的角色
    add_role_ids = new_role_ids - old_role_ids
    add_roles = Role.where(id: add_role_ids)
    add_roles.each do |role|
      EmployeeRole.create(employee_id: @employee.id, role_id: role.id)
    end
    # 删除现在没有的角色
    delete_role_ids = old_role_ids - new_role_ids
    delete_roles = Role.where(id: delete_role_ids)
    EmployeeRole.where(employee_id: @employee.id, role_id: delete_roles.pluck(:id)).delete_all if delete_roles.present?
  end

  def sign_in
    requires! :username, type: String # 手机号
    requires! :password, type: String # 密码

    @client_ip = client_ip
    @ip_region = client_ip_region
    
    employee = Employee.find_by(username: params[:username])
    error!("该账号不存在", 20007) and return if employee.blank?
    error!("密码错误", 20007) and return if !employee.authenticate(params[:password].to_s.strip)

    after_signin(employee)
  end

  def sign_out
    Employee.set_cache_api_token(current_employee.id, "")
  end

  private
  def employee_params
    params.permit(:username, :password, :password_confirmation, :name, :job_status, :position_id, :is_enabled, :joined_on, :mobile, :office_tel, :qq_num, :birthday)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def after_signin(employee)
    @employee = employee

    EmployeeService.update_signin_info_perform_later(employee, @client_ip, @ip_region)
    # 生成的是客户端的验证token
    @api_token = create_jwt(@employee)
  end
end