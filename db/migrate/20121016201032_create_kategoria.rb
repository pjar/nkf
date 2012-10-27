class CreateKategoria < ActiveRecord::Migration
  def change
    create_table :kategoria do |t|
      t.string :nazwa
      t.boolean :glowna

      t.timestamps
    end
  end
end
