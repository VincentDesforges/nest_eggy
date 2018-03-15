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
      redirect_to plan_path(@plan)
    else
      render :new
    end
  end

  def show
    @plan = Plan.find(params[:id])
    @chart_data = chart_data

    amount = (@plan.target_amount - @chart_data.last[1].to_i)
    years_ahead = @plan.target_year - Date.today.year
    @plan_status = amount / (years_ahead * 52)

    @average_per_week = (@chart_data.last[1].to_i - @chart_data.first[1].to_i)/52
  end

  private
  def plan_params
    params.require(:plan).permit(:name, :weekly_savings_target, :target_year, :target_amount, :bank_account_ids)
  end
  def chart_data
    data = []
    running_total = 0
    transactions = current_user.transactions.all
    sorted_transactions = transactions.sort_by{ |object| object.date }
    sorted_transactions.each do |transaction|
      data_point = []
      running_total += transaction.amount
      data_point << transaction.date
      data_point << running_total
      data << data_point
    end
    return data
  end
end
