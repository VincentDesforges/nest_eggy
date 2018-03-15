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
    @chart_data = chart_data
    @plan = Plan.find(params[:id])
    benchmark = linear_model(Date.today)
    @plan_data = plan_data
    @average_per_week = (@chart_data.last[1].to_i - @chart_data.first[1].to_i)/52
    # @plan = Plan.find_by user_id: current_user.id

    # Dummy data

    # @plan_data = plan_data
    # @average_per_week = average_per_week
    @plan_status = plan_status




    # amount = (@plan.target_amount - @chart_data.last[1].to_i)
    # years_ahead = @plan.target_year - Date.today.year

  end

  private
  def plan_params
    params.require(:plan).permit(:name, :weekly_savings_target, :target_year, :target_amount, :bank_account_ids)
  end

  def plan_accounts_balance
    balance_on_accounts = 0
    current_user.bank_accounts.each do |account| # <------- Here replace current_user with plan.bank_accounts
      balance_on_accounts += account.balance
    end
    return balance_on_accounts
  end

  def get_plan_accounts_transactions
    array = []
    current_user.bank_accounts.each do |account| # <------- Here replace current_user with plan.bank_accounts
      account.transactions.each do |transaction|
        array << transaction
      end
    end
    return array
  end

  def chart_data
    balance_today = plan_accounts_balance
    data = []
    running_total = 0
    transactions = get_plan_accounts_transactions # <---- This should be only the accounts considered
    sorted_transactions = transactions.sort_by{ |object| object.date }
    sorted_transactions.each do |transaction|
      data_point = []
      running_total += transaction.amount
      data_point << transaction.date
      data_point << running_total
      data << data_point
    end
    data_correction = balance_today - data.last[-1]
    data.each do |data_point|
      data_point[-1] += data_correction
    end
    return data
  end

  def linear_model(t)
    dydx = (@plan.target_amount - @chart_data.first[-1]) / (@plan.target_year * 365) # <------- start point wrong should be were plan is created
    return @chart_data.first[-1] + dydx * (t - @chart_data.first[0])
  end

  def plan_data
    data = []
    @chart_data.each do |chart_data_point|
      data_point = []
      data_point << chart_data_point[0]
      data_point << linear_model(chart_data_point[0])
      data << data_point
    end
    return data
  end

  def plan_status
    sum_returns = 0
    time_left = @plan.target_year + ((@chart_data.first[0] - Date.today)/365).round # <--------Here start date wrong should be were plan is created
    time_left.times do |i|
      sum_returns += 52 * (1.02**i)
    end
    new_weekly_savings_target = ((@plan.target_amount - @chart_data.last[1].to_i + @chart_data.first[1].to_i)/sum_returns).ceil(2)
    return new_weekly_savings_target
  end
end
