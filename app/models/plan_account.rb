class PlanAccount < ApplicationRecord
  belongs_to :plan
  belongs_to :bank_account
end
