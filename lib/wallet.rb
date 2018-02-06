require 'ostruct'
require 'wallet_conversion'

class Wallet < OpenStruct
  def initialize(currency, amount=0)
    super(currency: currency, amount: amount)
  end

  def value_avaiable?(value)
    raise Exception.new("Insufficient funds") unless self.amount >= value
    true
  end

  def receive(wallet_from, value)
    self.amount += WalletConversion.new().convert(wallet_from.currency, currency, value)
  end

  def withdraw(value)
    self.amount -= value if value_avaiable?(value)
  end
end
