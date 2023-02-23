module ApplicationHelper

  def format_api_time(time)
    time.to_i
  end

  def format_standard_time(time)
    return "" if time.blank?
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

end
