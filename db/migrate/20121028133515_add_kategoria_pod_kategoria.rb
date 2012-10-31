class AddKategoriaPodKategoria < ActiveRecord::Migration
  def up
    create_table :kategoria_pod_kategoria, :id => false do |t|
      t.integer :kategoria_id
      t.integer :pod_kategoria_id
    end
  end

  def down
    drop_table :kategoria_pod_kategoria
  end
end
