require 'spec_helper'
require 'wallet'
RSpec.describe Wallet, type: :model do

  let(:wallet) { Wallet.new("USD", 50.0) }
  let(:wallet_2) { Wallet.new("BRD", 50.0) }

  describe ".value_avaiable?" do
    it "return true if há o valor na carteira" do
      expect(wallet.value_avaiable?(25.0)).to eq(true)
    end

    it "return expection if not há saldo na carteira" do
      expect { wallet.value_avaiable?(75.0) }.to raise_error("Insufficient funds")
    end
  end

  describe ".receive" do
    it "wallet, send 1BRD for wallet_2" do
      wallet.receive(wallet_2, 1.0)
      expect(wallet.amount).to eq(50.32)
    end
  end

  describe ".withdraw" do
    it "Remove 50 USD from wallet" do
      wallet.withdraw(50)
      expect(wallet.amount).to eq(0)
    end

    it "Tries to withdraw more than the available value" do
      expect{wallet.withdraw(51)}.to raise_error("Insufficient funds")
    end
  end

end
