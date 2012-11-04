class CreateCategoriesRelationships < ActiveRecord::Migration
  def change
    create_table :categories_relationships, id: false do |t|
      t.integer :parent_category_id
      t.integer :sub_category_id
    end
  end
end
