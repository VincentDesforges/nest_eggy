require 'api_calls'

class BankAccountsController < ApplicationController

  def new
    @user = current_user
    user_details = {
      email: @user.email,
      password: @user.encrypted_password
    }

    @response = ApiCalls::RequestMethods.authenticate_user(user_details)
    @user.bearer_token = @response["access_token"]
    @user.save
    # raise # check whether ip address issue can be solved in production

    # >>>>>>>>>>>>>> Here add a form to "Ask which bank you are with"<<<<<<<<<<<<<<<<<<<<<<<
    redirect_to ApiCalls::RequestMethods.add_item(@user.bearer_token)
    # >>>>>>>>>>>>>> Before redirect add a form to "Ask which bank you are with"<<<<<<<<<<<<


    # @response = ApiCalls::RequestMethods.list_banks
    # @response = ApiCalls::RequestMethods.list_categories
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

  def bankin
  end
end
