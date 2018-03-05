class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.string :account_holder_name
      t.integer :account_number
      t.string :iban
      t.string :bank_name
      t.string :bank_address
      t.integer :sort_code
      t.float :balance
      t.string :currency
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
