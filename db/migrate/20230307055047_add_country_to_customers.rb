class AddCountryToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :country, :string, comment: "国家"
  end
end
