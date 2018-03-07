class Transaction < ApplicationRecord
  belongs_to :bank_account
  belongs_to :category

  validates :api_transaction_id, presence: true, uniqueness: true
end
