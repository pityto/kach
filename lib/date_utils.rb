module DateUtils

  # 为指定列表补全日期并添加指定属性为0
  # list: 结果集
  # start_at: 开始日期
  # end_at: 结束日期
  # attributes: 要添加的属性并设置值为0 { xxxx: 0 }
  def self.fill_up(list, start_at, end_at, attributes, is_desc = true)
    items = list.index_by {|item| item.stat_date.strftime("%Y-%m-%d")}
    date_num = (end_at - start_at).to_i.abs
    current_at = is_desc ? end_at : start_at
    result = []
    (0..date_num).each do |n|
      new_date = current_at.strftime("%Y-%m-%d")
      if items.has_key?(new_date)
        result << items[new_date].attributes.symbolize_keys
      else
        result << { stat_date: new_date.to_date }.merge!(attributes)
      end
      current_at = current_at.prev_day if current_at >= start_at && is_desc
      current_at = current_at.next_day if current_at <= end_at && !is_desc
    end
    result
  end

  def self.time2str(t)
    t.strftime("%Y-%m-%d %H:%M:%S")
  end

  def self.time2ymd(t)
    t.strftime("%Y%m%d")
  end

  def self.remaining_time
    (Time.now.end_of_day - Time.now).to_i
  end

  def self.remaining_time_of_day(d)
    ((Time.now.end_of_day + d.days) - Time.now).to_i
  end

end
