class SyncUserJob < ActiveJob::Base

  def perform(params)
    SyncToC3.sync_user_data(params[:class_name], params[:id])
  end
end
