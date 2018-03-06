require 'api_calls'

class BankAccountsController < ApplicationController

  def new
    @user = current_user
    user_details = {
      email: @user.email,
      password: @user.encrypted_password
    }

    @response = ApiCalls::RequestMethods.authenticate_user(user_details)
    bearer_token = @response["access_token"]

    # redirect_to ApiCalls::RequestMethods.add_item(bearer_token)

    # save the accounts info in the accounts table (list accounts)
    # save the transactions info in the transactions table (list transactions)




    # @response = ApiCalls::RequestMethods.list_banks
    # @response = ApiCalls::RequestMethods.single_bank
    # @response = ApiCalls::RequestMethods.list_users
    # @response = ApiCalls::RequestMethods.create_user(@user_details)
    # @response = ApiCalls::RequestMethods.authenticate_user(@user_details)
    # @response = ApiCalls::RequestMethods.list_accounts(bearer_token)
    # api_account_id = 10657952
    # @response = ApiCalls::RequestMethods.single_account(bearer_token, api_account_id)
    # redirect_to ApiCalls::RequestMethods.add_item(bearer_token)
    # @response = ApiCalls::RequestMethods.list_items(bearer_token)
    # @response = ApiCalls::RequestMethods.list_tansactions(bearer_token)

    # @response = ApiCalls::RequestMethods.clear_database # care lose all data!!!
  end
end
