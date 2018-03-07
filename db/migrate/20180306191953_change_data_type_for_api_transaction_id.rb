class ChangeDataTypeForApiTransactionId < ActiveRecord::Migration[5.1]
  def change
    change_column :transactions, :api_transaction_id, :bigint
  end
end
