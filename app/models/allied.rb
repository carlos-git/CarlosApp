class Allied
  #attr_reader :state, :city, :area_code, :time_zone

=begin
  def initialize(zip)
    # Gyoku.convert_symbols_to :camelcase
     client = Savon::Client.new("http://www.webservicex.net/uszip.asmx?WSDL")
    
    response = client.request :web, :get_info_by_zip, body: { "USZip" => zip }
    if response.success?
      data = response.to_array(:get_info_by_zip_response, :get_info_by_zip_result, :new_data_set, :table).first
      if data
        @state = data[:state]
        @city = data[:city]
        @area_code = data[:area_code]
        @time_zone = data[:time_zone]
      end
    end
  end
=end
  
  
  def initialize()
    # Gyoku.convert_symbols_to :camelcase
    client = Savon::Client.new("https://service.381808.com/Merchant.asmx?WSDL")
=begin    
    response = client.request :web, :execute_credit_card, 
      body: { 
           "MerchantID" => 'ed51de7b-55a6-49d4-afe1-64d7e3fcf6df',
            "SiteID" =>  'fd14c564-15a9-4c32-9f84-3ea7ed813e72',
            "IPAddress" => '127.0.1.1',
            "Amount" => '1.00',
            "CurrencyID" => 'USD',
            "FirstName" => 'Alash',
            "LastName" => 'Shah',
              "Phone" => '02213543543',
            "Address" => '135 sterling ave',
            "City" => 'city',
            "State" => 'state',
            "Country" => 'country',
            "ZipCode" => '07029',
            "Email" => 'akash.rockersinfo@gmail.com',
            "CardNumber" => 'execute_credit_card4242424242424242',
            "CardName" => 'John Doe',
            "ExpiryMonth" => 10,
            "ExpiryYear" => 10,
             "CardCVV" => '280' 
          
          }
    if response.success?
      data = response.to_array(:get_info_by_zip_response, :get_info_by_zip_result, :new_data_set, :table).first
      if data
        @state = data[:state]
        @city = data[:city]
        @area_code = data[:area_code]
        @time_zone = data[:time_zone]
      end
    end
=end       
  end

def self.execute_credit_card2(user_data)
 
    client = Savon.client(wsdl: 'https://service.381808.com/Merchant.asmx?WSDL')
    response = client.call(:execute_credit_card, 
    message: { 
        "MerchantID" => 'ed51de7b-55a6-49d4-afe1-64d7e3fcf6df',
            "SiteID" =>  'fd14c564-15a9-4c32-9f84-3ea7ed813e72',
            "IPAddress" => user_data[:ipaddress],
            "Amount" => user_data[:amount],
            "CurrencyID" => 'USD',
            "FirstName" => user_data[:first_name],
            "LastName" => user_data[:last_name],
            "Address" => '135 sterling ave',
            "City" => 'city',
            "State" => 'state',
            "Country" => 'country',
            "ZipCode" => '07029',
            "Email" => user_data[:email],
            "CardNumber" => user_data[:cardnumber],
            "CardName" => user_data[:cardname],
            "ExpiryMonth" => user_data[:expirymonth],
            "ExpiryYear" => user_data[:expiryyear],
             "CardCVV" => user_data[:cardcvv]  
      })
    
    if response.success?
      response.to_hash[:execute_credit_card_response][:execute_credit_card_result]  
    end
   
  
end
  
  def self.execute_credit_card
    # Gyoku.convert_symbols_to :camelcase
    client = Savon::Client.new("https://service.381808.com/Merchant.asmx?WSDL")
    response = client.request :web, :execute_credit_card, 
      body: { 
           "MerchantID" => 'ed51de7b-55a6-49d4-afe1-64d7e3fcf6df',
            "SiteID" =>  'fd14c564-15a9-4c32-9f84-3ea7ed813e72',
            "IPAddress" => '127.0.1.1',
            "Amount" => '3.50',
            "CurrencyID" => 'USD',
            "FirstName" => 'Akash',
            "LastName" => 'Shah',
              "Phone" => '02213543543',
            "Address" => '135 sterling ave',
            "City" => 'city',
            "State" => 'state',
            "Country" => 'country',
            "ZipCode" => '07029',
            "Email" => 'akash.rockersinfo@gmail.com',
            "CardNumber" => '4242424242424242',
            "CardName" => 'John Doe',
            "ExpiryMonth" => 10,
            "ExpiryYear" => 10,
             "CardCVV" => '280' 
          
          }
    if response.success?
      data = response.to_array(:get_info_by_zip_response, :get_info_by_zip_result, :new_data_set, :table).first
      if data
        @state = data[:state]
        @city = data[:city]
        @area_code = data[:area_code]
        @time_zone = data[:time_zone]
      end
    end
  end
  
end