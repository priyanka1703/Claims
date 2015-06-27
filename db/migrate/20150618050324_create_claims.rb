class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
	t.string :title
	t.string :summary
        t.float :amount
        t.string :status
	t.timestamp :date_paid
        t.references :user
      t.timestamps null: false
    end
  end
end
