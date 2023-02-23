json.page_datas @introductions do |introduction|
  json.partial! 'api/admin/v1/front_end/introductions/introduction', introduction: introduction
end
json.partial! "api/shared/page", items: @introductions