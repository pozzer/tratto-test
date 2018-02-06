require 'ostruct'
require 'wallet'
class Client < OpenStruct
  def initialize(name, wallets=[])
    super(name: name, wallets: wallets)
  end

  def export
    { name: name, wallets: wallets.map{|w| [w.currency, w.amount]}.to_h }
  end

  def find_possiblie_wallet(currency)
    begin
      find_wallet(currency)
    rescue Exception => e
      wallet = wallets.first
      raise Exception.new("No wallets found for #{self.name}") unless wallet
      wallet
    end
  end

  def find_wallet(currency)
    wallet = wallets.find{ |wallet| wallet.currency == currency }
    raise Exception.new("No #{currency} Wallet found for #{self.name}") unless wallet
    wallet
  end

end
#Dir["./*.rb"].each {|file| require file }
