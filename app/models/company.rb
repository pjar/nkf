class Company < ActiveRecord::Base
  belongs_to :category, counter_cache: true
  belongs_to :sub_category, foreign_key: :sub_category_id, counter_cache: true, class_name: 'Category'
  attr_accessible :adres, :description, :fax, :link, :nazwa, :tel, :website, :logo_url, :uniq_id, :sub_kategoria
end
