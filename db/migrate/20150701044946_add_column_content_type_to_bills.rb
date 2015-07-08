class AddColumnContentTypeToBills < ActiveRecord::Migration
  def change
     add_column :bills, :content_type, :string
  end
end
