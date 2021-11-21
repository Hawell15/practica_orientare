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

ActiveRecord::Schema.define(version: 20_211_119_111_311) do
  create_table 'categories', force: :cascade do |t|
    t.string 'category_name'
    t.string 'full_name'
    t.float 'points'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'clubs', force: :cascade do |t|
    t.string 'club_name'
    t.string 'territory'
    t.string 'representative'
    t.string 'email'
    t.string 'phone'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'competitions', force: :cascade do |t|
    t.string 'competition_name'
    t.date 'date'
    t.string 'location'
    t.string 'country'
    t.string 'distance_type'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'groups', force: :cascade do |t|
    t.string 'group_name'
    t.string 'clasa'
    t.float 'rang'
    t.integer 'competition_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['competition_id'], name: 'index_groups_on_competition_id'
  end

  create_table 'results', force: :cascade do |t|
    t.integer 'place'
    t.integer 'runner_id'
    t.integer 'time', default: 0
    t.integer 'category_id', default: 0
    t.integer 'group_id', default: 0
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['category_id'], name: 'index_results_on_category_id'
    t.index ['group_id'], name: 'index_results_on_group_id'
    t.index ['runner_id'], name: 'index_results_on_runner_id'
  end

  create_table 'runners', force: :cascade do |t|
    t.string 'runner_name'
    t.string 'surname'
    t.date 'dob'
    t.integer 'category_id', default: 10
    t.integer 'club_id', default: 0
    t.string 'gender'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['category_id'], name: 'index_runners_on_category_id'
    t.index ['club_id'], name: 'index_runners_on_club_id'
  end
end
