require 'rails_helper'

describe ApiClient do
  describe :hashkey do
    it do
      test_api_key = ENV.fetch("API_KEY")
      client = ApiClient.new('a', 'b', 1)
      sha1 = Digest::SHA1.hexdigest("foo&#{test_api_key}")

      allow(client).to receive(:params_string){ 'foo' }

      expect(client.hashkey).to eq(sha1)
    end
  end
end

