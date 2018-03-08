class AddAverageToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :average, :integer
  end
end
