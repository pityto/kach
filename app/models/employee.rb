class Employee < ApplicationRecord
  has_and_belongs_to_many :roles, :join_table => :employees_roles

  has_secure_password
  # 数据库不区分大小写，所以这里的验证也不区分
  validates :username, uniqueness: { message: "账号已存在", case_sensitive: false }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  CACHE_KEY_API_TOKENS = "employee_api_tokens"

  # 读写相关字段缓存值
  def self.set_cache_api_token(employee_id, token)
    key = CACHE_KEY_API_TOKENS + "_" + employee_id.to_s
    $redis.setex(key, 7.days.to_i, token)
  end

  def self.get_cache_api_token(employee_id)
    key = CACHE_KEY_API_TOKENS + "_" + employee_id.to_s
    api_token = $redis.get(key)
    api_token.blank? ? Employee.find(employee_id).api_token.to_s : api_token
  end

  # 是否管理员角色
  def admin?
    has_role? 'admin'
  end

  # 是否属于某个角色
  def has_role?(role_tag)
    Employee.emp_role_cache(self.id).include? role_tag.to_s
  end

  def self.emp_role_cache(id)
    return [] if id.to_i == 0
    Rails.cache.fetch("employee_#{id}_roles", expires_in: 30.minute) do
      e = Employee.find_by_id id
      e.present? ? e.roles.pluck(:name) : []
    end
  end

  def self.get_all_with_options
    Rails.cache.fetch("all_employees", expires_in: 30.minute) do
      Employee.all.order(:name).map {|emp| [emp.name,emp.id]}
    end
  end

end