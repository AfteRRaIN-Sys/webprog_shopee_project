# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_05_135524) do

  create_table "buckets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "quantity"
    t.index ["user_id"], name: "index_buckets_on_user_id"
  end

  create_table "buckets_items", id: false, force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "bucket_id", null: false
    t.integer "quantity"
    t.index ["bucket_id"], name: "index_buckets_items_on_bucket_id"
    t.index ["item_id"], name: "index_buckets_items_on_item_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "store_id", null: false
    t.index ["store_id"], name: "index_favorites_on_store_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "item_on_buckets", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "bucket_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bucket_id"], name: "index_item_on_buckets_on_bucket_id"
    t.index ["item_id"], name: "index_item_on_buckets_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "store_id", null: false
    t.string "name"
    t.float "price"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id"], name: "index_items_on_store_id"
  end

  create_table "items_buckets", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "bucket_id"
    t.index ["bucket_id"], name: "index_items_buckets_on_bucket_id"
    t.index ["item_id"], name: "index_items_buckets_on_item_id"
  end

  create_table "items_tags", id: false, force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "tag_id", null: false
    t.index ["item_id"], name: "index_items_tags_on_item_id"
    t.index ["tag_id"], name: "index_items_tags_on_tag_id"
  end

  create_table "order_line_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "item_id", null: false
    t.integer "quantity"
    t.float "sold_price"
    t.index ["item_id"], name: "index_order_line_items_on_item_id"
    t.index ["order_id"], name: "index_order_line_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "purchased_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "store_id", null: false
    t.integer "rate_score"
    t.string "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id"], name: "index_ratings_on_store_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "storeName"
    t.string "password_digest"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.string "name"
    t.string "address"
    t.string "phoneNo"
    t.string "gender"
    t.date "birthday"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "buckets", "users"
  add_foreign_key "favorites", "stores"
  add_foreign_key "favorites", "users"
  add_foreign_key "item_on_buckets", "buckets"
  add_foreign_key "item_on_buckets", "items"
  add_foreign_key "items", "stores"
  add_foreign_key "order_line_items", "items"
  add_foreign_key "order_line_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "ratings", "stores"
  add_foreign_key "ratings", "users"
end
