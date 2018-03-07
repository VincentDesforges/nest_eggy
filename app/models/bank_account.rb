class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :api_account_id, presence: true, uniqueness: true
end
