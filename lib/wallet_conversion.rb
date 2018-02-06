require 'ostruct'
class WalletConversion < OpenStruct

  def initialize(currencys = {usd: 1, brd: 3.16, eur: 0.8})
    super(currencys)
  end

  def to_usd(currency, val)
    val / send(currency.downcase)
  end

  def convert(from, to, val)
    from == to ? val : (to_usd(from, val) * send(to.downcase)).round(2)
  end
end
