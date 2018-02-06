require 'spec_helper'
require 'wallet_conversion'

RSpec.describe WalletConversion, type: :model do

  let(:wallet_conversion) { WalletConversion.new() }

  describe ".to_usd" do
    context "when converting" do
      it "USD to USD" do
        expect(wallet_conversion.convert("USD", "USD", 2.0)).to eq 2.0
      end
      it "USD to BRD" do
        expect(wallet_conversion.convert("USD", "BRD", 2.0)).to eq 6.32
      end
      it "USD to EUR" do
        expect(wallet_conversion.convert("USD", "EUR", 1)).to eq(0.8)
      end
    end
  end

  describe ".convert" do
    context "when USD Currency" do
        it "USD to USD" do
          expect(wallet_conversion.convert("USD", "USD", 2.0)).to eq 2.0
        end
        it "USD to BRD" do
          expect(wallet_conversion.convert("USD", "BRD", 2.0)).to eq 6.32
        end
        it "USD to EUR" do
          expect(wallet_conversion.convert("USD", "EUR", 2.0)).to eq(1.6)
        end
      end

    context "when BRD Currency" do
      it "BRD to BRD" do
        expect(wallet_conversion.convert("BRD", "BRD", 1.0)).to eq 1.0
      end
      it "BRD to USD" do
        expect(wallet_conversion.convert("BRD", "USD", 3.16)).to eq 1.0
      end

      it "BRD to EUR" do
        expect(wallet_conversion.convert("BRD", "EUR", 3.16)).to eq(0.8)
      end
    end

    context "when EUR Currency" do
      it "EUR to EUR" do
        expect(wallet_conversion.convert("EUR", "EUR", 1.0)).to eq 1.0
      end
      it "BRD to USD" do
        expect(wallet_conversion.convert("EUR", "USD", 1.0)).to eq 1.25
      end

      it "BRD to EUR" do
        expect(wallet_conversion.convert("EUR", "BRD", 1.0)).to eq(3.95)
      end
    end

    context "when does restore return to original values?" do
      it "BRD restore EUR" do
        euro = wallet_conversion.convert("EUR", "BRD", 1.0)
        expect(wallet_conversion.convert("BRD", "EUR", euro)).to eq(1.0)
      end

      it "BRD restore USD" do
        usd = wallet_conversion.convert("USD", "BRD", 1.0)
        expect(wallet_conversion.convert("BRD", "USD", usd)).to eq(1.0)
      end

      it "EUR restore USD" do
        usd = wallet_conversion.convert("EUR", "USD", 1.0)
        expect(wallet_conversion.convert("USD", "EUR", usd)).to eq(1.0)
      end
    end
  end

end
