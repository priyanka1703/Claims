class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :file
      t.references :claim

      t.timestamps null: false
    end
  end
end
