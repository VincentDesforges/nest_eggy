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
    @hash = {}
    @user.transactions.each do |transaction| # <-- add filter for week/month
      if transaction.amount <= 0
        unless @hash.include?(transaction.category.name)
          @hash[transaction.category.name] = transaction.amount * (-1)
        else
          @hash[transaction.category.name] += transaction.amount * (-1)
        end
      end
    end
  end

  def savings
    @chart_data = chart_data
    # Dummy data
    @plan_data = plan_data
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

  def plan_data
    data = []
    date = (Date.today - 12.months)
    running_total = 0
    24.times do
      data_point = []
      date += 1.month
      running_total += 500
      data_point << date
      data_point << running_total
      data << data_point
    end
    return data
  end

end
