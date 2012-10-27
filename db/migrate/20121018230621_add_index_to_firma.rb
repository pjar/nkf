class AddIndexToFirma < ActiveRecord::Migration
  def change
    add_index :firmas, :kategoria_id
    add_index :firmas, :uniq_id
  end
end
