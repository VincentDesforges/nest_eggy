class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.string :bank_name
      t.string :account_type
      t.string :account_name
      t.float :balance
      t.string :currency
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
