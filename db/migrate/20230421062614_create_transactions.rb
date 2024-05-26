class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.date :sending_time
      t.string :phone_number_or_email
      t.string :currency
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
