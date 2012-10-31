class AddPodKategoriaReferenceToFirma < ActiveRecord::Migration
  def change
    change_table :firmas do |t|
      t.references :pod_kategoria
    end
  end
end
