class AddApiAccountIdToBankAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :bank_accounts, :api_account_id, :integer
  end
end
