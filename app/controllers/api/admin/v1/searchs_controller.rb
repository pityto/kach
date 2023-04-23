class Api::Admin::V1::SearchsController < Api::Admin::V1::ApiController

  def products
    requires! :q, type: String # 搜索参数，cas号或产品名称
    
    @results = nil
    @term = sanitize_term(params[:q].to_s.strip)
    cas = Utils.check_cas(@term.scan(/\d+-\d+-\d/).flatten.first.to_s)
    if cas.present?
      @results = ::Product.where(cas: cas).page(param_page).per(param_limit)
    elsif @term.present?
      @term = @term.gsub("'", "\\\\'") if @term =~ /'/
      @results = ::Product.where("name like '%#{@term}%'").page(param_page).per(param_limit)
    end
  end

  def customers
    requires! :q, type: String # 搜索参数，传客户first_name或last_name

    @customers = Customer.where("first_name like '%#{params[:q]}%' or last_name like '%#{params[:q]}%'")
    @customers = @customers.page(param_page).per(param_limit)
  end

  private
  def sanitize_term(s)
    ActionController::Base.helpers.sanitize(s, tags: [])
  end
end