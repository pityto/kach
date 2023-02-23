json.page_datas @teams do |team|
  json.partial! 'api/admin/v1/hr/teams/team', team: team
end
json.partial! "api/shared/page", items: @teams