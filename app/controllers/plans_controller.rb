class PlansController < ApplicationController
  def new
    @plan = Plan.new
    @plan.target_year = 10
    @plan.target_amount = 50_000
    @plan.compute_weekly_savings!
  end

  def create

  end
end
