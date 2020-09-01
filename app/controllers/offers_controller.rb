class OffersController < ApplicationController
  def index
    @offers = Offer.all
  end

  def list
    offers = Offer.all
    render json: offers.to_json, status: 200
  end
end
