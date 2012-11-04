class ChangeFirmaModelNameToCompany < ActiveRecord::Migration
  def up
    rename_table :firmas, :companies
  end

  def down
    rename_table :companies, :firmas
  end
end
