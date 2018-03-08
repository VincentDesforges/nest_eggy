class Category < ApplicationRecord
  has_many :transactions

  # has_many :bank_accounts, through: :transactions
  # has_many :users, through: :bank_accounts

  validates :name, :api_category_id, presence: true
  validates :api_category_id, uniqueness: true
end
