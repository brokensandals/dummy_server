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

ActiveRecord::Schema.define(:version => 20120121201835) do

  create_table "hits", :force => true do |t|
    t.integer  "rule_id"
    t.string   "env"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
    t.string   "name"
    t.string   "method_pattern"
    t.string   "path_pattern"
    t.integer  "precedence"
    t.integer  "response_status"
    t.text     "response_headers"
    t.text     "response_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delay",            :default => 0
  end

end
