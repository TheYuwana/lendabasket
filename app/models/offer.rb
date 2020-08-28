class Offer
  attr_reader :id, :interest, :confirmed_funding, :country,
    :funding_expires_at, :funding_target, :intro, :impact_indicators,
    :name, :published_at, :maturity_in_months, :number_of_investors

  class << self
    include Enumerable
    delegate :each, to: :all

    def all
      offers_hash.map { |hsh| new(hsh.deep_symbolize_keys) }
    end

    private

    def offers_hash
      JSON.parse(fixtures).fetch("data", [])
    end

    def fixtures
      File.read(
        Rails.root.join("lib/fixtures/offers.json")
      )
    end
  end

  def initialize(id:, attributes:)
    @id = id.to_i
    @attrs = attributes

    SIMPLE_ATTRS.each do |attr|
      instance_variable_set("@#{attr}", attributes[attr])
    end

    @interest = attrs[:annualized_interest].to_f
    @published_at = Date.parse(attrs[:published_at])
    @funding_expires_at = Date.parse(attrs[:funding_expires_at])
    @funding_target = monetized(:funding_target_cents)
    @confirmed_funding = monetized(:confirmed_funding_cents)
  end

  def available_amount
    funding_target - confirmed_funding
  end

  def funding_percentage
    ((confirmed_funding / funding_target) * 100).floor
  end

  private

  SIMPLE_ATTRS = %i[
    name
    intro
    country
    sector
    impact_indicators
    maturity_in_months
    number_of_investors
  ].freeze

  attr_reader :attrs

  def monetized(amount_cents)
    Money.new(attrs[amount_cents], attrs[:currency])
  end
end
