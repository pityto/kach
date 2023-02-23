json.page_datas @leave_words do |leave_word|
  json.partial! 'api/admin/v1/crm/leave_words/leave_word', leave_word: leave_word
end
json.partial! "api/shared/page", items: @leave_words