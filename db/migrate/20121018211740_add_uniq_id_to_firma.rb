class AddUniqIdToFirma < ActiveRecord::Migration
  def change
    add_column :firmas, :uniq_id, :string
  end
end
