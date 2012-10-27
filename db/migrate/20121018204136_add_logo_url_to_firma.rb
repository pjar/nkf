class AddLogoUrlToFirma < ActiveRecord::Migration
  def change
    add_column :firmas, :logo_url, :string
  end
end
