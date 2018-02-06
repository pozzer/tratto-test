require 'csv'
require 'client'
require 'wallet'
class FileParser

  def self.load_client_wallets(file_path)
    @objects = []
    CSV.foreach(File.open(file_path, "r"), headers: true) do |row|
      client = find_or_build_client(OpenStruct.new(row.to_hash))
      @objects << client if client
    end
    @objects
  end

  private

    def self.find_or_build_client(object)
      wallet = Wallet.new(object.Currency, object.Amount.to_f)
      client = @objects.find{|c| c.name == object.Client }
      if client
        client.wallets << wallet
        return
      else
        Client.new(object.Client, [wallet])
      end
    end

end
