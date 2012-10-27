class CreateFirmas < ActiveRecord::Migration
  def change
    create_table :firmas do |t|
      t.string :nazwa
      t.text :adres
      t.string :tel
      t.string :fax
      t.string :link
      t.text :description
      t.string :website
      t.references :kategoria

      t.timestamps
    end
  end
end
