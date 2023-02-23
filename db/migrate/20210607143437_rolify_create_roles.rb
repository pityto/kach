class RolifyCreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :employees, comment: "员工表" do |t|
      t.string :username, default: "", null: false, comment: "账号"
      t.string :password_digest, default: "", null: false, comment: "密码"
      t.string :api_token, default: "", comment: "应用API TOKEN"
      t.string :name, limit: 20, comment: "名字"
      t.integer :position_id, default: 0, null: false, comment: '职位,0-其它,1-销售,2-采购'
      t.integer :job_status, default: 1, null: false, comment: "在职状态, 1:在职, -1:离职"
      t.date :joined_on, comment: "入职日期"
      t.string :mobile, limit: 30, comment: "手机"
      t.string :office_tel, limit: 30, comment: "公司电话"
      t.string :qq_num, comment: "qq号"
      t.date :birthday, comment: "生日"
      t.boolean :is_enabled, default: true, comment: "是否启用，1-是，0-否"
      t.datetime :current_signin_at, default: nil, comment: "当前登录时间"
      t.string :current_signin_ip, default: "", comment: "当前登录ip"
      t.datetime :last_signin_at, default: nil, comment: "上次登录时间  "
      t.string :last_signin_ip, default: "", comment: "上次登录ip"
      t.integer :signin_count, default: 0, comment: "登录次数"
      t.timestamps
    end
    add_index :employees, :username, unique: true

    create_table(:roles) do |t|
      t.string :name, comment: "角色名称"
      t.string :name_cn, comment: "中文名"
      t.references :resource, :polymorphic => true
      t.timestamps
    end

    create_table(:employees_roles, :id => false) do |t|
      t.references :employee
      t.references :role
    end
    
    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:employees_roles, [ :employee_id, :role_id ])
  end
end
