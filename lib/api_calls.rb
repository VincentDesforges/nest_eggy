module ApiCalls
  class RequestMethods
    @api_options = {
      base_uri: 'https://sync.bankin.com/v2/',
      bankin_version: "2016-01-18",
      bank_id: 408,
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"],
      bearer_token: '',
      has_bearer: false,
      until_date: '2018-03-06',
      redirect_url: 'http://localhost:3000/transaction_history'
    }

    def self.reset_bearer_data
      @api_options[:has_bearer] = false
      @api_options[:bearer_token] = ''
    end

    def self.api_get_request(uri, api_options)
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{api_options[:bearer_token]}" if api_options[:has_bearer]
      req['Bankin-Version'] = api_options[:bankin_version]

      res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(req)
      }
      JSON.parse(res.body)
    end

    def self.api_post_request(uri, api_options)
      req = Net::HTTP::Post.new(uri)
      req['Authorization'] = "Bearer #{api_options[:bearer_token]}" if api_options[:has_bearer]
      req['Bankin-Version'] = api_options[:bankin_version]

      res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(req)
      }
      JSON.parse(res.body)
    end

    def self.list_banks
      uri = URI("#{@api_options[:base_uri]}banks?client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      api_get_request(uri, @api_options)
    end

    def self.single_bank
      uri = URI("#{@api_options[:base_uri]}banks/#{@api_options[:bank_id]}?client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      api_get_request(uri, @api_options)
    end

    def self.list_users
      uri = URI("#{@api_options[:base_uri]}users?limit=100&client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      api_get_request(uri, @api_options)
    end

    def self.create_user(user_details)
      uri = URI("#{@api_options[:base_uri]}users?email=#{user_details[:email]}&password=#{user_details[:password]}&client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      api_post_request(uri, @api_options)
    end

    def self.authenticate_user(user_details)
      uri = URI("#{@api_options[:base_uri]}authenticate?email=#{user_details[:email]}&password=#{user_details[:password]}&client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      api_post_request(uri, @api_options)
    end

    def self.list_accounts(bearer_token)
      uri = URI("#{@api_options[:base_uri]}accounts?limit=10&client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      @api_options[:has_bearer] = true
      @api_options[:bearer_token] = bearer_token
      output = api_get_request(uri, @api_options)
      reset_bearer_data
      return output
    end

    def self.single_account(bearer_token, api_account_id)
      uri = URI("#{@api_options[:base_uri]}accounts/#{api_account_id}?client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      @api_options[:has_bearer] = true
      @api_options[:bearer_token] = bearer_token
      output = api_get_request(uri, @api_options)
      reset_bearer_data
      return output
    end

    def self.add_item(bearer_token)
      url = "#{@api_options[:base_uri]}items/connect?bank_id=#{@api_options[:bank_id]}&client_id=#{@api_options[:client_id]}&access_token=#{bearer_token}&redirect_url=#{@api_options[:redirect_url]}"
    end

    def self.list_items(bearer_token)
      uri = URI("#{@api_options[:base_uri]}items?client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}&limit=100")
      @api_options[:has_bearer] = true
      @api_options[:bearer_token] = bearer_token
      output = api_get_request(uri, @api_options)
      reset_bearer_data
      return output
    end

    def self.list_tansactions(bearer_token)
      uri = URI("#{@api_options[:base_uri]}transactions?limit=50&until=#{@api_options[:until_date]}&client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      @api_options[:has_bearer] = true
      @api_options[:bearer_token] = bearer_token
      output = api_get_request(uri, @api_options)
      reset_bearer_data
      return output
    end

    def self.clear_database
      uri = URI("#{@api_options[:base_uri]}users?client_id=#{@api_options[:client_id]}&client_secret=#{@api_options[:client_secret]}")
      req = Net::HTTP::Delete.new(uri)
      req['Bankin-Version'] = @api_options[:bankin_version]
      res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
        http.request(req)
      }
    end
  end
end
