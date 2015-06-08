class OffersController < ApplicationController
  def index
    @search = OpenStruct.new(params[:search])
    @offers = if params[:search]
                client = ApiClient.new(@search.uid, @search.pub0, @search.page)
                client.offers
              end
  rescue => e
    flash.now[:error] = e.message
  end
end
