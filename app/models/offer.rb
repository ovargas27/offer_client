class Offer
  attr_accessor :title, :offer_id, :teaser, :required_actions, :link, :offer_types, :payout, :time_to_payout, :thumbnail, :store_id

  def self.new_from_hash(hash)
    offer = Offer.new
    hash.each do |key, value|
      offer.send("#{key}=", value) if offer.respond_to? key
    end
    offer
  end
end

