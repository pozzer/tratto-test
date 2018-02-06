require 'spec_helper'
require 'client'

RSpec.describe Client, type: :model do

  let(:client) { Client.new("jon", [Wallet.new("USD", 50.0), Wallet.new("EUR", 20.0)]) }

  describe ".find_wallet" do
    context "when having currency Wallet " do
      it "return Wallet object" do
        expect(client.find_wallet("USD").class).to eq(Wallet)
      end
    end

    context "when not having currency Wallet " do
      it "return Exception" do
        expect { client.find_wallet("BRD") }.to raise_error "No BRD Wallet found for #{client.name}"
      end
    end
  end

  describe ".find_possiblie_wallet" do
    context "IF not having Wallet BRD" do
      it "return first wallet for client" do
        expect(client.find_possiblie_wallet("BRD").class).to eq Wallet
      end

      it "return Exception if wallets is empty" do
        client.wallets = []
        expect { client.find_possiblie_wallet("BRD") }.to raise_error "No wallets found for #{client.name}"
      end

    end
  end

  describe ".export" do
    it "return hash with name e all wallets" do
      expect(client.export).to eq({:name=>"jon", :wallets=>{"USD"=>50.0, "EUR"=>20.0}})
    end
  end

end
