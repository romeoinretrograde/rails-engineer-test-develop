class CreateCompaniesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :companies_tables do |t|
      t.string :coc_number, null: false
      t.string :company_name, null: false
      t.string :city, null: false

      t.timestamps
    end

    add_index :companies, :coc_number, unique: true
    add_index :companies, :company_name
    add_index :companies, :city  
  end
end
