class SubCategory < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :companies
  attr_accessible :companies_count, :name
end
