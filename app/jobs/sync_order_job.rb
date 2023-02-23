class SyncOrderJob < ActiveJob::Base

  def perform(params)
    success, resp = SyncToC3.sync_order_data(params[:id])
    if !success
      resp = (JSON.parse(resp)).symbolize_keys
      if resp[:status] == 466
        ids = Chemical.find_by(cas: resp[:cas])&.pluck(:id)
        if ids.present?
          ids.each do|chemical_id|
            SyncToC3.sync_chemical_data(chemical_id)
          end
        end
      end
    end
  end
end
