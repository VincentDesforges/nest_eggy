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


    if @plan.save
      params["plan"]['bank_account_ids'].each do |bank_id|
        if PlanAccount.create(plan: @plan, bank_account_id: bank_id)
          puts "Plan account pairing saved"
        else
          render :new
        end
      end
      redirect_to svg_path
    else
      render :new
    end
  end

  def index
    @plans = Plan.all
  end

  private
  def plan_params
    params.require(:plan).permit(:weekly_savings_target, :target_year, :target_amount, :bank_account_ids)
  end
end
