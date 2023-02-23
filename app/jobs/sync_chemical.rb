class SyncChemicalJob < ActiveJob::Base

  def perform(params)
    SyncToC3.sync_chemical_data(params[:id])
  end
end
