require 'rails_helper'

describe ApiClient do
  describe "#hashkey" do
    it do
      test_api_key = ENV.fetch("API_KEY")
      client = ApiClient.new('a', 'b', 1)
      sha1 = Digest::SHA1.hexdigest("foo&#{test_api_key}")

      allow(client).to receive(:params_string){ 'foo' }

      expect(client.hashkey).to eq(sha1)
    end
  end

  describe "#validate_signature" do
    context "valid signature" do
      it do
        client = ApiClient.new('a', 'b', 1)
        valid = client.validate_signature('b1aebea01807bb3d651fa4ff62cf223e5a441785', "{\"foo\":\"bar\"}")

        expect(valid).to be true
      end
    end

    context "Invalid signature" do
      it do
        client = ApiClient.new('a', 'b', 1)
        valid = client.validate_signature('this-is-invalid', "{\"foo\":\"bar\"}")

        expect(valid).to be false
      end
    end
  end
end

