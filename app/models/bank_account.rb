class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions

  has_many :plan_accounts
  has_many :plans, through: :plan_accounts

  validates :api_account_id, presence: true, uniqueness: true
end
