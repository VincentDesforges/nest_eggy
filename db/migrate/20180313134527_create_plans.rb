class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.integer :target_year
      t.integer :target_amount
      t.float :weekly_savings_target
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
