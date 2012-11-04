class Category < ActiveRecord::Base
  has_many :companies_from_all_sub_categories, foreign_key: :category_id, class_name: 'Company'
  has_many :companies, foreign_key: :sub_category_id
  has_and_belongs_to_many :sub_categories, class_name: 'Category',
                          join_table: 'categories_relationships',
                          foreign_key: 'parent_category_id',
                          association_foreign_key: 'sub_category_id',
                          uniq: true
                          
  attr_accessible :main, :name
  attr_readonly :companies_count

  scope :main, where(main: true)
  scope :sub_categories, where(main: [nil, false])
end
