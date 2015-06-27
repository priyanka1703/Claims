class AddFileToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :file, :string
  end
end
