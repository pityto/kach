module Mapping
  extend ActiveSupport::Concern

  WHITESPACE_REGEXP = /\u001f/
  INVALID_UTF8_REGEX = /[\u0000-\u0019]|\u200b/
  CHINESE_REGEXP = /[\u4e00-\u9fa5]/

  included do
    include Elasticsearch::Model

    index_name "weihua-#{Rails.env}"
    document_type 'chemicals'
    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mappings  do
        indexes :cas, type: 'keyword'
        indexes :name_cn, type: 'keyword'
        indexes :names, type: 'keyword'
        indexes :names_keywords, type: 'text', analyzer: 'keyword'
        indexes :names_cn, type: 'keyword'
        indexes :names_cn_keywords, type: 'text', analyzer: 'smartcn'
        indexes :status, type:  'integer'
        indexes :suggest, type: 'completion', analyzer: 'snowball'
        indexes :suggest_cn, type: 'completion', analyzer: 'smartcn'
      end
    end
  end


  def as_indexed_json(options = {})
    {
      cas: self.cas.to_s.strip,
      names: self.suggests,
      names_keywords: self.suggest_keywords,
      name_cn: self.name_cn.to_s,
      names_cn: self.suggests_cn,
      names_cn_keywords: self.suggests_cn_keywords,
      status: self.search_status,
      suggest: { input: self.suggests },
      suggest_cn: { input: self.chinese_keywords }
    }
  end

  def search_status
    return 0 if self.inactive?
    return 0 if self.sale_restriction?
    1
  end

  def chinese_keywords
    suggests_cn.map do |k|
      k.to_s.strip.scan(/#{CHINESE_REGEXP}+/)
    end.flatten.uniq.select {|k| k.size > 1}
  end

  def suggests_cn
    s = []
    s.push self.name_cn.to_s.gsub(INVALID_UTF8_REGEX,'').gsub(WHITESPACE_REGEXP,' ').strip
    s.push self.cn_aliases.pluck(:name)
    s.flatten!
    s.compact!
    s.uniq
  end

  def suggests_cn_keywords
    s = []
    s.push self.name_cn.to_s.gsub(INVALID_UTF8_REGEX,'').gsub(WHITESPACE_REGEXP,' ').strip
    s.push self.display_cn_aliases.to_s.gsub(INVALID_UTF8_REGEX,'').gsub(WHITESPACE_REGEXP,' ').gsub("；",";").strip.split(";")
    s.flatten!
    s = s.map {|n| n.to_s.strip.downcase}
    s = s.select {|n| n.present?}
    s.uniq
  end

  def suggest_keywords
    s = []
    s.push self.name.to_s.downcase.gsub(INVALID_UTF8_REGEX,'').gsub(WHITESPACE_REGEXP,' ').scan(/[a-z]+/).find_all{|i| i.size >= 2}.uniq
    s.push self.display_en_aliases.to_s.downcase.gsub(INVALID_UTF8_REGEX,'').gsub(WHITESPACE_REGEXP,' ').scan(/[a-z]+/).find_all{|i| i.size >= 2}.uniq
    s.flatten!
    s = s.map {|n| n.to_s.strip.downcase}
    s = s.select {|n| n.present?}
    s.uniq
  end

  def suggests
    s = []
    s.push self.name.to_s.downcase
    s.push self.en_aliases.pluck(:name)
    s.flatten!
    s.compact!
    s = s.map { |n| n.to_s.strip.downcase }
    s.uniq
  end

end
