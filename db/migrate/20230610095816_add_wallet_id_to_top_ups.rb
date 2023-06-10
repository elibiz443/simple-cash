class AddWalletIdToTopUps < ActiveRecord::Migration[7.0]
  def change
    add_column :top_ups, :wallet_id, :bigint
  end
end
