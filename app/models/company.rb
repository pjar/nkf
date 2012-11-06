class Company < ActiveRecord::Base
  belongs_to :category, counter_cache: true
  belongs_to :sub_category, foreign_key: :sub_category_id, counter_cache: true, class_name: 'Category'

  attr_accessible :address, :description, :fax, :link, :name, :tel, :website, :logo_url, :uniq_id
end
