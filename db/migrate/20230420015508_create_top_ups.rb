class CreateTopUps < ActiveRecord::Migration[7.0]
  def change
    create_table :top_ups do |t|
      t.float :amount
      t.string :phone_number

      t.timestamps
    end
  end
end
