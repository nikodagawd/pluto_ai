class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.text :system_prompt
      t.string :company_name, null: false
      t.string :address
      t.string :city
      t.string :country
      t.text :description
      t.decimal :revenue, precision: 15, scale: 2
      t.string :owner
      t.integer :employees
      t.string :sector
      t.string :sub_sector
      t.string :website
      t.integer :founded_year

      t.timestamps
    end

    add_index :companies, :company_name
    add_index :companies, :city
    add_index :companies, :country
    add_index :companies, :sector
    add_index :companies, :sub_sector
    add_index :companies, :founded_year
  end
end
