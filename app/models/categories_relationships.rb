class CategoriesRelationships < ActiveRecord::Base
  attr_accessible :parent_category_id, :sub_category_id

  has_and_belongs_to_many :parent_categories, class_name: 'Category',
                          join_table: 'categories_relationships',
                          foreign_key: 'sub_category_id',
                          association_foreign_key: 'parent_category_id',
                          uniq: true
end
