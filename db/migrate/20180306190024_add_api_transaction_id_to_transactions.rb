class AddApiTransactionIdToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :api_transaction_id, :integer
  end
end
