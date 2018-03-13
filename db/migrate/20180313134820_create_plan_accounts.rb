class CreatePlanAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_accounts do |t|
      t.references :plan, foreign_key: true
      t.references :bank_account, foreign_key: true

      t.timestamps
    end
  end
end
