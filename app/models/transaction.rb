class Transaction < ApplicationRecord
  belongs_to :bank_account

  validates :api_transaction_id, presence: true, uniqueness: true
end
