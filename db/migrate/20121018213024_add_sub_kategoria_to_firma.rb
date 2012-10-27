class AddSubKategoriaToFirma < ActiveRecord::Migration
  def change
    add_column :firmas, :sub_kategoria, :string
  end
end
