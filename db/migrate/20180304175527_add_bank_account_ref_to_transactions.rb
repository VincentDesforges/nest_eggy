class AddBankAccountRefToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :bank_account, foreign_key: true
  end
end
