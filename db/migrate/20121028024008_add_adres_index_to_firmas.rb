class AddAdresIndexToFirmas < ActiveRecord::Migration
  def change
    add_index :firmas, :adres, length: { adres: 128 }
  end
end
