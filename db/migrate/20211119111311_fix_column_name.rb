class FixColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :categories, :name, :category_name
    rename_column :clubs, :name, :club_name
    rename_column :clubs, :territory, :territory
    rename_column :competitions, :name, :competition_name
    rename_column :groups, :name, :group_name
    rename_column :runners, :name, :runner_name
  end
end
