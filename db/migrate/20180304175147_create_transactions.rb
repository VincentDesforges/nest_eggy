class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :account_number
      t.float :amount
      t.string :currency
      t.string :authorization_code
      t.float :payment_fees
      t.text :description
      t.string :merchant
      t.string :merchant_address
      t.string :transaction_status
      t.string :category

      t.timestamps
    end
  end
end
