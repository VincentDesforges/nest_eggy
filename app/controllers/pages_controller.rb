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

    @response_categories = ApiCalls::RequestMethods.list_categories
    @response_categories["resources"].each do |category_hash|
      category = Category.new
      category.api_category_id = category_hash["id"]
      category.name = category_hash["name"]
      category.parent_id = category_hash["parent"]["id"] if category_hash["parent"]
      category.save
    end
  end

  def savings
  end

  def breakdown
  end
end
