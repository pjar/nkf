class AddEmailToFirmas < ActiveRecord::Migration
  def change
    add_column :firmas, :email, :string
  end
end
