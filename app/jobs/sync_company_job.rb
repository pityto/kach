class SyncCompanyJob < ActiveJob::Base

  def perform(params)
    SyncToC3.sync_company_data(params[:id])
  end
end
