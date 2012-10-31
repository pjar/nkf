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

ActiveRecord::Schema.define(:version => 20121028135130) do

  create_table "firmas", :force => true do |t|
    t.string   "nazwa"
    t.text     "adres"
    t.string   "tel"
    t.string   "fax"
    t.string   "link"
    t.text     "description"
    t.string   "website"
    t.integer  "kategoria_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "logo_url"
    t.string   "uniq_id"
    t.string   "sub_kategoria"
    t.string   "email"
    t.integer  "pod_kategoria_id"
  end

  add_index "firmas", ["adres"], :name => "index_firmas_on_adres", :length => {"adres"=>128}
  add_index "firmas", ["kategoria_id"], :name => "index_firmas_on_kategoria_id"
  add_index "firmas", ["uniq_id"], :name => "index_firmas_on_uniq_id"

  create_table "kategoria", :force => true do |t|
    t.string   "nazwa"
    t.boolean  "glowna"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "kategoria_pod_kategoria", :id => false, :force => true do |t|
    t.integer "kategoria_id"
    t.integer "pod_kategoria_id"
  end

  create_table "pod_kategoria", :force => true do |t|
    t.string   "nazwa"
    t.integer  "liczba_firm"
    t.integer  "kategoria_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "pod_kategoria", ["kategoria_id"], :name => "index_pod_kategoria_on_kategoria_id"
  add_index "pod_kategoria", ["nazwa"], :name => "index_pod_kategoria_on_nazwa", :length => {"nazwa"=>128}

end
