class CreatePodKategoria < ActiveRecord::Migration
  def change
    create_table :pod_kategoria do |t|
      t.string :nazwa
      t.integer :liczba_firm
      t.references :kategoria

      t.timestamps
    end
    add_index :pod_kategoria, :kategoria_id
  end
end
