class RenameColumnInClaims < ActiveRecord::Migration
  def change
  rename_column :claims, :date_expenditure, :exp_date
  rename_column :claims, :date_paid, :reiumbersed_at 
  end
end
