class BankAccountsController < ApplicationController
  def new
    base_uri = 'https://sync.bankin.com/v2/'
    bankin_version ="2016-01-18"
    @user = current_user
    simulation_bank_id = 408
    email = "example@example.com"
    password = "123456"
    client_id = ENV["CLIENT_ID"]
    client_secret = ENV["CLIENT_SECRET"]

    api_options = {
      base_uri: base_uri,
      bankin_version: bankin_version,
      bank_id: simulation_bank_id,
      email: email,
      password: password,
      client_id: client_id,
      client_secret: client_secret
    }

    # @response = list_banks(api_options)
    # @response = single_bank(api_options)
    # @response = list_users(api_options)
    # @response = create_user(api_options)
    # @response = authenticate_user(api_options)
  end




  private


  def api_get_request(uri, bankin_version)
    req = Net::HTTP::Get.new(uri)
    req['Bankin-Version'] = bankin_version

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(req)
    }
    JSON.parse(res.body)
  end

  def api_post_request(uri, bankin_version)
    req = Net::HTTP::Post.new(uri)
    req['Bankin-Version'] = bankin_version

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
      http.request(req)
    }
    JSON.parse(res.body)
  end

  def list_banks(api_options)
    uri = URI("#{api_options[:base_uri]}banks?client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_get_request(uri, api_options[:bankin_version])
  end

  def single_bank(api_options)
    uri = URI("#{api_options[:base_uri]}banks/#{api_options[:bank_id]}?client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_get_request(uri, api_options[:bankin_version])
  end

  def list_users(api_options)
    uri = URI("#{api_options[:base_uri]}users?limit=100&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_get_request(uri, api_options[:bankin_version])
  end

  def create_user(api_options)
    uri = URI("#{api_options[:base_uri]}users?email=#{api_options[:email]}&password=#{api_options[:password]}&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_post_request(uri, api_options[:bankin_version])
  end

  def authenticate_user(api_options)
    uri = URI("#{api_options[:base_uri]}authenticate?email=#{api_options[:email]}&password=#{api_options[:password]}&client_id=#{api_options[:client_id]}&client_secret=#{api_options[:client_secret]}")
    api_post_request(uri, api_options[:bankin_version])
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
