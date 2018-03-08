require 'api_calls'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :test_components]

  def home
  end

  def test_components
    @users = User.all
  end

  def transaction_history
    @user = current_user

    # save the accounts info in the accounts table (list accounts)
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

    # save the transactions info in the transactions table (list transactions)
    @response_transactions = ApiCalls::RequestMethods.list_tansactions(@user.bearer_token)
    @response_transactions["resources"].each do |transaction_hash|
      transaction = Transaction.new
      transaction.amount = transaction_hash["amount"]
      transaction.currency = transaction_hash["currency_code"]
      transaction.description = transaction_hash["description"]
      transaction.category = transaction_hash["category"]["id"] # Change this to category name
      transaction.date = transaction_hash["date"]
      transaction.api_transaction_id = transaction_hash["id"]
      transaction.bank_account = BankAccount.where(api_account_id: transaction_hash["account"]["id"]).first
      transaction.save

    end
  end

  def savings
    @savings_data = savings_account_data
    @current_data = current_account_data
    @securities_data = securities_account_data
    @total_balance = (securities_balance + savings_balance + checking_balance).to_i
    @securities_balance = securities_balance
    @savings_balance = savings_balance
    @checking_balance = checking_balance
    @average_weekly_saving = average_weekly_saving
    @retirement_projection_data = retirement_projection_data
  end

  def breakdown
  end

  private

  # <---------- SAVINGS PAGE METHODS ---------->

  def savings_account_data
    account = current_user.bank_accounts.find_by account_type: 'savings'
    net_transactions = 0
    account.transactions.each do |transaction|
      net_transactions += transaction.amount
    end
    starting_balance = (account.balance - net_transactions)
    sorted_transactions = account.transactions.sort.reverse
    data = []
    sorted_transactions.each do |transaction|
      data_point = []
      starting_balance += transaction.amount
      data_point << transaction.date
      data_point << starting_balance.to_i
      data << data_point
    end
    return data
  end

  def current_account_data
    account = current_user.bank_accounts.find_by account_type: 'checking'
    net_transactions = 0
    account.transactions.each do |transaction|
      net_transactions += transaction.amount
    end
    starting_balance = (account.balance - net_transactions)
    sorted_transactions = account.transactions.sort.reverse
    data = []
    sorted_transactions.each do |transaction|
      data_point = []
      starting_balance += transaction.amount
      data_point << transaction.date
      data_point << starting_balance.to_i
      data << data_point
    end
    return data
  end

  def securities_account_data
    account = current_user.bank_accounts.find_by account_type: 'securities'
    net_transactions = 0
    account.transactions.each do |transaction|
      net_transactions += transaction.amount
    end
    starting_balance = (account.balance - net_transactions)
    sorted_transactions = account.transactions.sort.reverse
    data = []
    sorted_transactions.each do |transaction|
      data_point = []
      starting_balance += transaction.amount
      data_point << transaction.date
      data_point << starting_balance.to_i
      data << data_point
    end
    return data
  end

  def calculate_saving
    net_transactions = 0
    current_user.transactions.each do |transaction|
      net_transactions += transaction.amount
    end
    return net_transactions
  end

  def securities_balance
    securities = current_user.bank_accounts.find_by account_type: 'securities'
    return securities.balance
  end

  def savings_balance
    savings = current_user.bank_accounts.find_by account_type: 'savings'
    return savings.balance
  end

  def checking_balance
    checking = current_user.bank_accounts.find_by account_type: 'checking'
    return checking.balance
  end

  def average_weekly_saving
    sorted_transactions = current_user.transactions.sort.reverse
    period = (sorted_transactions.last.date - sorted_transactions.first.date).to_i
    return (calculate_saving / (period / 7 )).to_i
  end

  def retirement_projection_data
    running_total = @total_balance
    data = [[0, running_total]]
    year = 0
    40.times do
      data_point = []
      year += 1
      running_total = (running_total * 1.05) + (250 * 52)
      data_point << year
      data_point << running_total
      data << data_point
    end
    return data
  end


end
