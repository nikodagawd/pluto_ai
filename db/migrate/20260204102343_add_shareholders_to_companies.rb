class AddShareholdersToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :shareholders, :jsonb
  end
end
