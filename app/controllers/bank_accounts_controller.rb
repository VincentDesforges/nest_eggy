require 'api_calls'

class BankAccountsController < ApplicationController

  def new
    @user = current_user
    bearer_token = '90590727414157c206a6ed7d4d3b3908918cbc0f-357b7c9f-9114-40fa-bf1c-133b332949cd'
    api_account_id = 10657952

    # email = "john.doe@email.com"
    # password = "a!StrongP455word"
    # @user_details = {
    #   email: email,
    #   password: password
    # }


    # @response = ApiCalls::RequestMethods.list_banks
    # @response = ApiCalls::RequestMethods.single_bank
    @response = ApiCalls::RequestMethods.list_users
    # @response = ApiCalls::RequestMethods.create_user(@user_details)
    # @response = ApiCalls::RequestMethods.authenticate_user(@user_details)
    # @response = ApiCalls::RequestMethods.list_accounts(bearer_token)
    # @response = ApiCalls::RequestMethods.single_account(bearer_token, api_account_id)
    # redirect_to ApiCalls::RequestMethods.add_item(bearer_token)
    # @response = ApiCalls::RequestMethods.list_items(bearer_token)
    # @response = ApiCalls::RequestMethods.list_tansactions(bearer_token)

    # @response = ApiCalls::RequestMethods.clear_database # care lose all data!!!
  end




  private


end



  # def new

  #   @user = current_user
  #   redirect 'https://sync.bankin.com/v2/authenticate?email=john.doe@email.com&password=a!StrongP455word&client_id=>>>>>><<<<<&client_secret=>>>>><<<<<<<'
  # end

  # def create
  #   token = 'token'

  #   pass to js
  #   we get info in js

  #   pass to ruby
  #   # info = apirequest(token)<---- use code stored somewhere else
  #   # Account.create(info)


  #   redirect to dashboard
  # end
