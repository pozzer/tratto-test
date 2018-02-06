require 'spec_helper'
require 'wallet_central'
require 'file_parser'

RSpec.describe WalletCentral, type: :model do

  let(:wallet_central) { WalletCentral.new(File.dirname(__FILE__) +"/resources/wallets.csv") }

  describe ".transfer" do
    context "when everything is alright" do
      it "Show OK" do
        expect(wallet_central.transfer("jon", "arya", "USD", 5.0)).to eq("OK")
      end
    end

    context "when the funds is not available" do
      it "show Exception" do
        expect{ wallet_central.transfer("jon", "arya", "USD", 5100.0) }.to raise_error("Insufficient funds")
      end
    end

    context "when you can not find the currency wallet for the transfer" do
      it "show Exception" do
        expect{ wallet_central.transfer("jon", "arya", "BRD", 5.0)}.to raise_error("No BRD Wallet found for jon")
      end
    end
  end

  describe ".output" do
    context "when you send the name as a parameter" do
      it "shows the client and his wallets" do
        expect(wallet_central.output('jon')).to eq({:name=>"jon", :wallets=>{"EUR"=>868.65, "USD"=>463.39}})
      end

      it "shows all clients and his wallets if client not found" do
        expect(wallet_central.output('jons')).to eq([{:name=>"jon", :wallets=>{"EUR"=>868.65, "USD"=>463.39}}, {:name=>"arya", :wallets=>{"EUR"=>1379.78, "USD"=>0.0}}, {:name=>"sansa", :wallets=>{"EUR"=>1065.45, "BRL"=>586.28}}])
      end
    end

    context "when you not send the name as a parameter" do
      it "shows all clients and his wallets" do
        expect(wallet_central.output).to eq([{:name=>"jon", :wallets=>{"EUR"=>868.65, "USD"=>463.39}}, {:name=>"arya", :wallets=>{"EUR"=>1379.78, "USD"=>0.0}}, {:name=>"sansa", :wallets=>{"EUR"=>1065.45, "BRL"=>586.28}}])
      end
    end
  end

  describe ".find_client" do
    context 'when client is found' do
      it "returns client object" do
        expect(wallet_central.send("find_client","jon").class).to eq(Client)
      end
    end

    context 'when client is not found' do
      it "return Exception" do
        expect{ wallet_central.send("find_client", "jons") }.to raise_error("Client jons not found.")
      end
    end
  end

  describe ".transaction" do
    it "when success transaction" do
      jon_wallet = wallet_central.send("find_client","jon").find_wallet("USD")
      arya_wallet = wallet_central.send("find_client","arya").find_wallet("USD")
      arya_before_amount = arya_wallet.amount
      jon_before_amount = jon_wallet.amount
      wallet_central.send("transaction", jon_wallet, arya_wallet, 50.0)
      expect(arya_wallet.amount).to eq(arya_before_amount + 50.0)
      expect(jon_wallet.amount).to eq(jon_before_amount - 50.0)
    end
  end

end
