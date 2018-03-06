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
    # save the transactions info in the transactions table (list transactions)
    @response_transactions = ApiCalls::RequestMethods.list_tansactions(@user.bearer_token)

  end

  def savings
  end

  def breakdown
  end
end
