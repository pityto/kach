class SyncInquiryJob < ActiveJob::Base

  def perform(params)
    SyncToC3.sync_inquiry_data(params[:id])
  end
end
