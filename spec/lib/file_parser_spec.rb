require 'spec_helper'
require 'file_parser'

RSpec.describe FileParser, type: :model do

  describe "#load_client_wallets" do
    it "load csv and return a of clients with wallets" do
      expect(FileParser.load_client_wallets(File.dirname(__FILE__) +"/resources/wallets.csv").size). to eq(3)
    end
  end

  describe "#find_or_build_client" do
      context "when client not found, create new client with same name" do

      it "return new Client with one wallet" do
        FileParser.instance_variable_set(:@objects,[])
        expect(FileParser.send("find_or_build_client", OpenStruct.new({"Client": "jon", "Currency": "USD", "Amount": "50"})).export).to eq({:name=>"jon", :wallets=>{"USD"=>50.0}})
      end

      context "when client found" do
        it "push new wallet in client " do
          FileParser.instance_variable_set(:@objects,[FileParser.send("find_or_build_client", OpenStruct.new({"Client": "jon", "Currency": "USD", "Amount": "50"}))])
          expect(FileParser.send("find_or_build_client", OpenStruct.new({"Client": "jon", "Currency": "BRD", "Amount": "50"}))).to eq(nil)
        end
      end

    end

  end
end
