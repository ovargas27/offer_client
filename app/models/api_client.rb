class ApiClient
  attr_reader :api_key, :appid, :device_id, :ip, :locale, :offer_types, :page, :pub0, :timestamp, :uid

  def initialize(uid, pub0, page)
    @api_key     = ENV['API_KEY']
    @appid       = ENV['APP_ID']
    @device_id   = ENV['DEVICE_ID']
    @ip          = '109.235.143.113'
    @locale      = 'de'
    @offer_types = '112' # Free offers
    @timestamp   = Time.now.to_i

    @uid  = uid
    @pub0 = pub0
    @page = page
  end

  def offers
    json_response = get_offers
    hash_response = JSON.parse(json_response)
    if hash_response['code'] == 'OK'
      hash_response['offers'].map do |hash|
        Offer.new_from_hash(hash)
      end
    else
      []
    end
  end

  def get_offers
    request_url = "http://api.sponsorpay.com/feed/v1/offers.json?#{params_string}&hashkey=#{hashkey}"

    uri = URI(request_url)
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(request)
    end

    if response.is_a? Net::HTTPSuccess
      signature = response['X-Sponsorpay-Response-Signature']
      if validate_signature(signature, response.body)
        response.body
      else
        {'code' => 'Invalid response'}
      end
    else
      response.value
    end
  end

  def validate_signature(response_signature, response_body)
    valid_signature = Digest::SHA1.hexdigest("#{response_body}#{@api_key}")
    response_signature == valid_signature
  end

  def params_string
    @params_string ||= "appid=#{@appid}&device_id=#{@device_id}&ip=#{@ip}&locale=#{@locale}&offer_types=#{@offer_types}&page=#{@page}&pub0=#{@pub0}&timestamp=#{@timestamp}&uid=#{@uid}"
  end

  def hashkey
    Digest::SHA1.hexdigest("#{params_string}&#{@api_key}")
  end
end

