class AddNameToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :name, :string
  end
end
