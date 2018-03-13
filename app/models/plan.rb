class Plan < ApplicationRecord
  belongs_to :user

  validates :target_year, presence: true
  validates :target_year, presence: true
  validates :weekly_savings_target, presence: true

  def compute_weekly_savings!
    sum_returns = 0
    target_year.times do |i|
      sum_returns += 52 * (1.02**i)
    end
    self.weekly_savings_target = (target_amount/sum_returns).ceil(2)
  end
end
