module Search
  CHINESE_REGEXP = /[\u4e00-\u9fa5]/
  extend ActiveSupport::Concern

  module ClassMethods

    def es_suggest(term)
      field = 'suggest'
      field = 'suggest_cn' if term =~ CHINESE_REGEXP
      Chemical.__elasticsearch__.client.suggest(index: Chemical.index_name, body: {
        suggests: {
        text: term,
        completion: { field: field, size: 10 }
      }
      })
    end


    def es_search(term)
      query= {
        bool: {
          must: [
            {
              term: {
                status: { value: 1, boost: 0 }
              }
            },
          ],
          should: []
        }
      }
      #如果不是搜索cas号，cas号而不参与匹配
      query[:bool][:should].push({term: {cas: {value: term}}}) if term =~ /^[\d\-]+$/
      if term =~ CHINESE_REGEXP
        query[:bool][:should].push({constant_score: { filter: { term: { names_cn: term }}, boost: 9}})
        query[:bool][:should].push({match: { names_cn_keywords: term }})
      else
        query[:bool][:should].push({match: { names: { query: term.downcase, boost: 3 }}})
        query[:bool][:should].push({match: {names_keywords: term.downcase}})
      end

      search({
        query: query,
        min_score: 0.50
      })
    end

    # 按照字段搜索
    def es_filter(opt)
      query= {
        bool: {
          must: [
            {
              term: {
                status: { value: 1, boost: 0 }
              }
            },
          ],
          should: []
        }
      }
      opt.each do |k,v|
        query[:bool][:should].push({match: {"#{k}" => v}})
      end
      search({
        query: query,
        min_score: 0.50
      })
    end

  end

end