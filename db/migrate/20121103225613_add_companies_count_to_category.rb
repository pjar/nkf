class AddCompaniesCountToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :companies_count, :integer
  end
end
