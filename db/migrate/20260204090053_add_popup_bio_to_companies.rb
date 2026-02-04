class AddPopupBioToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :popup_bio, :text
  end
end
