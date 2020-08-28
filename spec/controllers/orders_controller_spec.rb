require "rails_helper"

RSpec.describe OrdersController do
  describe "POST create" do
    subject(:perform_request) do
      post(
        :create,
        params: {
          data: { attributes: order_params }
        }
      )
    end

    let(:order_params) do
      {
        currency: "EUR",
        payment_method: "ideal",
        investments: { "45": 150, "48": 100 }
      }
    end

    it { is_expected.to have_http_status(:created)}

    it "returns the order params" do
      perform_request
      attrs = JSON.parse(response.body).dig("data", "attributes")
      expect(attrs).to eql(
        "currency" => "EUR",
        "investor_id" => 14621,
        "payment_method" => "ideal",
        "reference" => "70222949cc0db89ab32c9969754d4758",
        "status" => "initialized"
      )
    end

    context "when investment is not available" do
      let(:order_params) do
        {
          currency: "EUR",
          payment_method: "ideal",
          investments: { "45": 150, "50": 100 }
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity)}
    end

    context "when funding target would be exceeded" do
      let(:order_params) do
        {
          currency: "EUR",
          payment_method: "ideal",
          investments: { "45": 69000, "48": 100 }
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity)}
    end

    context "when payment method is unavailable" do
      let(:order_params) do
        {
          currency: "EUR",
          payment_method: "paypal",
          investments: { "45": 150, "48": 100 }
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity)}
    end
  end
end
