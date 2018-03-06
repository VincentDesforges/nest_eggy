class BankAccountsController < ApplicationController
  def new
    base_uri = 'https://sync.bankin.com/v2/'
    bankin_version ="2016-01-18"
    @user = current_user
    simulation_bank_id = 408
    email = "john.doe@email.com"
    password = "a!StrongP455word"
    client_id = ENV["CLIENT_ID"]
    client_secret = ENV["CLIENT_SECRET"]
    bearer_token = 'd312710b501d9ccba7a31db6a3cf13128c753490-50c2df4b-6c0b-4dee-b25a-5bf63e339a18'
    api_account_id = 10648786
    until_date = '2018-03-06'
    redirect_url = 'http://localhost:3000/test_components'

    api_options = {
      base_uri: base_uri,
      bankin_version: bankin_version,
      bank_id: simulation_bank_id,
      email: email,
      password: password,
      client_id: client_id,
      client_secret: client_secret,
      has_bearer: false,
      bearer_token: bearer_token,
      api_account_id: api_account_id,
      until_date: until_date,
      redirect_url: redirect_url
    }

    # @response = list_banks(api_options)
    # @response = single_bank(api_options)
    # @response = list_users(api_options)
    # @response = create_user(api_options)
    # @response = authenticate_user(api_options)
    # @response = list_accounts(api_options)
    # @response = single_account(api_options)
    # add_item(api_options)
    # @response = list_items(api_options)
    # @response = list_tansactions(api_options)

    # @response = clear_database(api_options) # care lose all data!!!
  end




  private


  def api_get_request(uri, api_options)
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{api_options[:bearer_token]}" if api_options[:has_bearer]
    req['Bankin-Version'] = api_options[:bankin_version]

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(req)
    }
    JSON.parse(res.body)
  end

  def api_post_request(uri, api_options)
    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "Bearer #{api_options[:bearer_token]}" if api_options[:has_bearer]
    req['Bankin-Version'] = api_options[:bankin_version]

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(req)
    }
    JSON.parse(res.body)
  end

  def list_banks(api_options)
    uri = URI("#{api_options[:base_uri]}banks?client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_get_request(uri, api_options)
  end

  def single_bank(api_options)
    uri = URI("#{api_options[:base_uri]}banks/#{api_options[:bank_id]}?client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_get_request(uri, api_options)
  end

  def list_users(api_options)
    uri = URI("#{api_options[:base_uri]}users?limit=100&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_get_request(uri, api_options)
  end

  def create_user(api_options)
    uri = URI("#{api_options[:base_uri]}users?email=#{api_options[:email]}&password=#{api_options[:password]}&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_post_request(uri, api_options)
  end

  def authenticate_user(api_options)
    uri = URI("#{api_options[:base_uri]}authenticate?email=#{api_options[:email]}&password=#{api_options[:password]}&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_post_request(uri, api_options)
  end

  def list_accounts(api_options)
    uri = URI("#{api_options[:base_uri]}accounts?limit=10&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_options[:has_bearer] = true
    api_get_request(uri, api_options)
  end

  def single_account(api_options)
    uri = URI("#{api_options[:base_uri]}accounts/#{api_options[:api_account_id]}?client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_options[:has_bearer] = true
    api_get_request(uri, api_options)
  end

  def add_item(api_options)
    url = "#{api_options[:base_uri]}items/connect?bank_id=#{api_options[:bank_id]}&client_id=#{api_options[:client_id]}&access_token=#{api_options[:bearer_token]}&redirect_url=#{api_options[:redirect_url]}"
    # !!!!!!!
    redirect_to url
  end

  def list_items(api_options)
    uri = URI("#{api_options[:base_uri]}items?client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}&limit=100")
    api_options[:has_bearer] = true
    api_get_request(uri, api_options)
  end

  def list_tansactions(api_options)
    uri = URI("#{api_options[:base_uri]}transactions?limit=12&until=#{api_options[:until_date]}&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_options[:has_bearer] = true
    api_get_request(uri, api_options)
  end

  def clear_database(api_options)
    uri = URI("#{api_options[:base_uri]}users?client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    req = Net::HTTP::Delete.new(uri)
    req['Bankin-Version'] = api_options[:bankin_version]
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(req)
    }
  end
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
