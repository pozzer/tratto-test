class WalletCentral
  def initialize(file_path=File.dirname(__FILE__) +"/resources/wallets.csv")
    @clients = FileParser.load_client_wallets(file_path)
  end

  #WalletCentral.transfer(jon, arya, 'USD', 500)
  def transfer(from, to, currency, value)
    begin
      from_wallet = find_client(from).find_wallet(currency)
      to_wallet = find_client(to).find_wallet(currency)
      transaction(from_wallet, to_wallet, value)
      return "OK"
    rescue Exception => e
      raise e
    end
  end

  def output(name=nil)
    begin
      find_client(name).export
    rescue Exception => e
      @clients.map(&:export)
    end
  end

  private

    def transaction(wallet_from, wallet_to, value)
      wallet_from.withdraw(value)
      wallet_to.receive(wallet_from, value)
    end

    def find_client(name)
      client = @clients.find{|client| client.name == name}
      raise Exception.new("Client #{name} not found.") unless client
      client
    end

end
