# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121103225613) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "main"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "companies_count"
  end

  create_table "categories_relationships", :id => false, :force => true do |t|
    t.integer "parent_category_id"
    t.integer "sub_category_id"
  end

  create_table "categories_sub_categories", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "sub_category_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "tel"
    t.string   "fax"
    t.string   "link"
    t.text     "description"
    t.string   "website"
    t.integer  "category_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "logo_url"
    t.string   "uniq_id"
    t.string   "sub_category"
    t.string   "email"
    t.integer  "sub_category_id"
  end

  add_index "companies", ["address"], :name => "index_companies_on_address", :length => {"address"=>128}
  add_index "companies", ["category_id"], :name => "index_companies_on_category_id"
  add_index "companies", ["sub_category_id"], :name => "index_companies_on_sub_category_id"
  add_index "companies", ["uniq_id"], :name => "index_companies_on_uniq_id"

  create_table "sub_categories", :force => true do |t|
    t.string   "name"
    t.integer  "companies_count"
    t.integer  "category_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "sub_categories", ["category_id"], :name => "index_sub_categories_on_category_id"
  add_index "sub_categories", ["name"], :name => "index_sub_categories_on_name", :length => {"name"=>128}

end
