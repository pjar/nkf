class AddIndexToPodKategoriaOnNazwa < ActiveRecord::Migration
  def change
    add_index :pod_kategoria, :nazwa, length: { nazwa: 128 }
  end
end
