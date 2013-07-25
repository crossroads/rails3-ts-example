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

ActiveRecord::Schema.define(:version => 20130716061525) do

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "region"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries_documents", :id => false, :force => true do |t|
    t.integer "country_id"
    t.integer "document_id"
  end

  add_index "countries_documents", ["country_id", "document_id"], :name => "index_countries_documents_on_country_id_and_document_id", :unique => true

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.boolean  "delta",      :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "documents_images", :id => false, :force => true do |t|
    t.integer "document_id"
    t.integer "image_id"
  end

  add_index "documents_images", ["document_id", "image_id"], :name => "index_documents_images_on_document_id_and_image_id", :unique => true

  create_table "documents_subscribers", :id => false, :force => true do |t|
    t.integer "document_id"
    t.integer "subscriber_id"
  end

  add_index "documents_subscribers", ["document_id", "subscriber_id"], :name => "index_documents_subscribers_on_document_id_and_subscriber_id", :unique => true

  create_table "documents_tags", :id => false, :force => true do |t|
    t.integer "document_id"
    t.integer "tag_id"
  end

  add_index "documents_tags", ["document_id", "tag_id"], :name => "index_documents_tags_on_document_id_and_tag_id", :unique => true

  create_table "documents_videos", :id => false, :force => true do |t|
    t.integer "document_id"
    t.integer "video_id"
  end

  add_index "documents_videos", ["document_id", "video_id"], :name => "index_documents_videos_on_document_id_and_video_id", :unique => true

  create_table "images", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subscribers", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "level"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
