# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
emp = Employee.find_or_initialize_by(username: "admin")
emp.password = "111111"
emp.password_confirmation = "111111"
emp.name = '管理员'
emp.save
role = Role.find_or_initialize_by(name: "admin")
role.name_cn = '管理员'
role.save
EmployeeRole.find_or_create_by(employee_id: emp.id, role_id: role.id)