json.code 0
json.message @message || ""
json.data JSON.parse(yield) if @code == 0
