class RenameColumnNamesToEnglish < ActiveRecord::Migration
  def change
    remove_index! :pod_kategoria, :index_pod_kategoria_on_kategoria_id
    remove_index! :pod_kategoria, :index_pod_kategoria_on_nazwa
    remove_index! :companies, :index_firmas_on_adres
    remove_index! :companies, :index_firmas_on_kategoria_id
    remove_index! :companies, :index_firmas_on_uniq_id

    rename_column :companies, :nazwa, :name
    rename_column :companies, :adres, :address
    rename_column :companies, :kategoria_id, :category_id
    rename_column :companies, :sub_kategoria, :sub_category
    rename_column :companies, :pod_kategoria_id, :sub_category_id

    rename_table :kategoria, :category
    rename_column :category, :nazwa, :name
    rename_column :category, :glowna, :main
    
    
    rename_table :pod_kategoria, :sub_category
    rename_column :sub_category, :nazwa, :name
    rename_column :sub_category, :liczba_firm, :companies_count
    rename_column :sub_category, :kategoria_id, :category_id

    rename_table :kategoria_pod_kategoria, :category_sub_category
    rename_column :category_sub_category, :kategoria_id, :category_id
    rename_column :category_sub_category, :pod_kategoria_id, :sub_category_id

    add_index :sub_category, :name, length: { name: 128 }
    add_index :sub_category, :category_id
    add_index :companies, :category_id
    add_index :companies, :sub_category_id
    add_index :companies, :uniq_id
    add_index :companies, :address, length: { address: 128 }
    
  end

end
