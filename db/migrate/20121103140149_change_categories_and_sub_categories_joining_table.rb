class ChangeCategoriesAndSubCategoriesJoiningTable < ActiveRecord::Migration
  def change
    rename_table :category_sub_category, :categories_sub_categories
  end
end
