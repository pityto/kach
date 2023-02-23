class Api::Admin::V1::Crm::LeaveWordsController < Api::Admin::V1::ApiController

  def index
    optional! :first_name, type: String # first_name
    optional! :last_name, type: String # last_name
    optional! :phone, type: String # phone
    optional! :company_name, type: String # company_name
    optional! :email, type: String # email
    optional! :page, type: Integer # 页码
    optional! :limit, type: Integer # 单页条数
    
    @leave_words = LeaveWord.all
    @leave_words = @leave_words.where("first_name like '%#{params[:first_name]}%'") if params[:first_name].present?
    @leave_words = @leave_words.where("last_name like '%#{params[:last_name]}%'") if params[:last_name].present?
    @leave_words = @leave_words.where("phone like '%#{params[:phone]}%'") if params[:phone].present?
    @leave_words = @leave_words.where("company_name like '%#{params[:company_name]}%'") if params[:company_name].present?
    @leave_words = @leave_words.where("email like '%#{params[:email]}%'") if params[:email].present?
    @leave_words = @leave_words.order(created_at: :desc).page(param_page).per(param_limit)
  end

end