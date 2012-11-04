class ChangeCategoryAndSubCategoryToPlural < ActiveRecord::Migration
  def change
    remove_index! :sub_category, :index_sub_category_on_name
    remove_index! :sub_category, :index_sub_category_on_category_id

    rename_table :category, :categories
    rename_table :sub_category, :sub_categories

    add_index :sub_categories, :name, length: { name: 128 }
    add_index :sub_categories, :category_id
  end
end
