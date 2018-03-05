class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :currency
      t.text :description
      t.string :category
      t.date :date

      t.timestamps
    end
  end
end
