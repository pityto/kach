json.selected_role_ids @selected_role_ids
json.roles @roles do |role|
  json.id role.id
  json.name role.name
  json.name_cn  role.name_cn
end
