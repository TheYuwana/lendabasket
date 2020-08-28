class OrdersController < ApplicationController
  before_action :validate_investments, :validate_payment_method, only: :create

  PAYMENT_METHODS = %w[ideal creditcard]

  def create
    render json: succes_body.to_json, status: 201
  end

  private

  def validate_investments
    return if investments_available? && investments_within_funding_target?
    render json: error_body.to_json, status: 422
  end

  def validate_payment_method
    return if PAYMENT_METHODS.include?(order_params[:payment_method])
    render json: error_body.to_json, status: 422
  end

  def investments_available?
    order_params[:investments].keys.all? do |offer_id|
      Offer.map(&:id).include?(offer_id.to_i)
    end
  end

  def investments_within_funding_target?
    order_params[:investments].to_h.all? do |offer_id, amount|
      offer = Offer.find { |offer| offer.id == offer_id.to_i }
      offer.available_amount.to_i >= amount.to_i
    end
  end

  def order_params
    params.require(:data).require(:attributes).permit(
      :currency, :payment_method, investments: {}
    )
  end

  def succes_body
    {
      data: {
        id: rand(1..999),
        type: "order",
        attributes: {
          currency: order_params[:currency],
          investor_id: 14621,
          payment_method: order_params[:payment_method],
          reference: "70222949cc0db89ab32c9969754d4758",
          status: "initialized",
        },
        relationships: { investments: { data: investments } }
      }
    }
  end

  def error_body
    {
      "errors": [
        {
          "status": "Unprocessable Entity",
          "code": 422,
          "title": "Project unavailable",
          "details": "One of your investments is for a project that is " \
                     "unavailable. Please check if any project has fulfilled " \
                     "its target funding."
        }
      ]
    }
  end

  def investments
    order_params[:investments].to_h.length.times.map do
      { id: rand(1..999), type: "investment" }
    end
  end
end
