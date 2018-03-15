require 'api_calls'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :test_components]

  def home
  end

  def test_components
    @users = User.all
    # @response = ApiCalls::RequestMethods.clear_database # care lose all data!!!
  end

  def transaction_history
    @user = current_user
    if params[:reload_acc_trans]
      # save the accounts info in the accounts table (list accounts)
      fetch_accounts
      # save the transactions info in the transactions table (list transactions)
      fetch_transactions
    end
    if params[:reload_cat]
      fetch_categories
    end



    if params["/transaction_history"].present? # Search by description or give all
      @transactions = @user.transactions.search_by_description_and_category(params["/transaction_history"][:query]).order(date: :desc)
      @transactions = @user.transactions.order(date: :desc) if params["/transaction_history"][:query] == ""
    else
      @transactions = @user.transactions.order(date: :desc)
    end


    unless params[:account_id] == "Account Name" || params[:account_id].blank? # if params[:account_id].present?
      @transactions = @transactions.where(bank_account_id: params[:account_id])
    end

    unless params[:currency] == "Currency" || params[:currency].blank? # if params[:currency].present?
      @transactions = @transactions.where(currency: params[:currency])
    end


    respond_to do |format|
      format.html
        format.js { render "transaction_history",
          locals: { transactions: @transactions }
        }
    end
  end

  def breakdown
    @user = current_user
    compute_my_spendings
    compute_country_spendings
  end

  def savings
    @plans = Plan.where(user: current_user)
    @accounts = BankAccount.where(user: current_user)
    @balance = balance
  end


  def stocks
    @user = current_user
    if params[:reload_stocks]
      fetch_stocks
    end
  end

  private

  def fetch_accounts
    @response_accounts = ApiCalls::RequestMethods.list_accounts(@user.bearer_token)
    @response_accounts["resources"].each do |account_hash|
      account = BankAccount.new
      account.bank_name = account_hash["bank"]["id"] #change to name later
      account.account_type = account_hash["type"]
      account.account_name = account_hash["name"]
      account.balance = account_hash["balance"]
      account.currency = account_hash["currency_code"]
      account.api_account_id = account_hash["id"]
      account.user = @user
      account.save
    end
  end

  def compute_my_spendings
    @my_spendings = {}
    @user.transactions.each do |transaction| # <-- add filter for week/month
      if transaction.amount <= 0 && transaction.date.month == Date.today.month
        unless @my_spendings.include?(transaction.category.name)
          @my_spendings[transaction.category.name] = transaction.amount * (-1)
        else
          @my_spendings[transaction.category.name] += transaction.amount * (-1)
        end
        @my_spendings.keys.sort
      end
    end
  end

  def compute_country_spendings
    @country_spendings = {}
    @user.transactions.each do |transaction|
      if transaction.amount <= 0
        unless @country_spendings.include?(transaction.category.name)
          @country_spendings[transaction.category.name] = transaction.category.average
        end
      end
    end
  end


  def fetch_transactions
    @response_transactions = ApiCalls::RequestMethods.list_tansactions(@user.bearer_token)
    @response_transactions["resources"].each do |transaction_hash|
      transaction = Transaction.new
      transaction.amount = transaction_hash["amount"]
      transaction.currency = transaction_hash["currency_code"]
      transaction.description = transaction_hash["description"]
      transaction.category = Category.find_by(api_category_id: transaction_hash["category"]["id"])
      transaction.date = transaction_hash["date"]
      transaction.api_transaction_id = transaction_hash["id"]
      transaction.bank_account = BankAccount.where(api_account_id: transaction_hash["account"]["id"]).first
      transaction.save
    end
  end

  def fetch_categories
    @response_categories = ApiCalls::RequestMethods.list_categories
    @response_categories["resources"].each do |category_hash|
      category = Category.new
      category.api_category_id = category_hash["id"]
      category.name = category_hash["name"]
      category.parent_id = category_hash["parent"]["id"] if category_hash["parent"]
      category.save
    end
  end

  def fetch_stocks
    @response_stocks = ApiCalls::RequestMethods.list_stocks(@user.bearer_token)
    # raise
  end


  # <----------------- Start of Transaction data methods ------------------------>
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

  # <----------------- End of Transaction data methods ------------------------>

  # <----------------- Start of Plan data methods ------------------------>

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

  def average_per_week
    (@chart_data.last[1].to_i - @chart_data.first[1].to_i)/52 # <---- this should use the model function?
  end
  # <----------------- End of Plan data methods ------------------------>

# <----------------- Start of Savings methods ------------------------>

def balance
  accounts = BankAccount.where(user: current_user)
  sum = 0
  accounts.each do |account|
    sum += account.balance
  end
  return sum
end












end
