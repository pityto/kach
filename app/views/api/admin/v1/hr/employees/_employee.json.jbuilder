json.id employee.id
json.username employee.username
json.name employee.name
json.job_status employee.job_status
json.joined_on format_standard_time(employee.joined_on)
json.mobile employee.mobile
json.office_tel employee.office_tel
json.qq_num employee.qq_num
json.birthday format_standard_time(employee.birthday)
json.position_id employee.position_id
json.is_enabled employee.is_enabled ? 1 : 0