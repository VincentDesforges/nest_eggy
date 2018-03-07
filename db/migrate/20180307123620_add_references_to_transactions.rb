class AddReferencesToTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :category, :string
    add_reference :transactions, :category, foreign_key: true
  end
end
