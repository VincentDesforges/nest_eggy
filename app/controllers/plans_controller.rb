class PlansController < ApplicationController
  def new
    @plan = Plan.new
    @plan.target_year = 10
    @plan.target_amount = 50_000
    @plan.compute_weekly_savings!

    @bank_accounts_options = current_user.bank_accounts
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user

    raise

    # if @plan.save
    #   redirect_to plan_path(@plan)
    # else
    #   render :new
    # end


    if @plan.save
      @bank_accounts_options.each do |bank|
        PlanAccount.create!(plan: @plan, bank: bank)
      end
      redirect_to plan_path(@plan)
    else
      render :new
    end
  end

  private
  def plan_params
    params.require(:plan).permit(:weekly_savings_target, :target_year, :target_amount)
  end
end
