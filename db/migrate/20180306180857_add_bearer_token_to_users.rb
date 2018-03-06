class AddBearerTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bearer_token, :string
  end
end
