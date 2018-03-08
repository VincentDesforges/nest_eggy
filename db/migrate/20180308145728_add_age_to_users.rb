class AddAgeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :integer
    add_column :users, :retirement_age, :integer
  end
end
