class AddColumnToClaims < ActiveRecord::Migration
  def change
     add_column :claims, :date_expenditure, :date
  end
end
