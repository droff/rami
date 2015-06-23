module RAMI
  class Listener
    class << self
      attr_reader :sock, :data
    end

    def self.init(host, port)
      begin
        @sock = TCPSocket.open(host, port)
      rescue
        nil
      end
    end

    def self.auth(username, secret)
      auth = "Action: login\nUsername: #{username}\nSecret: #{secret}\nEvent: on\n\n"

      @sock.puts(auth)
      @sock.recv(1000)
    end

    def self.run
      @data = @sock.recv(5000)
      unless @data.empty?
        yield if block_given?
      else
        @sock.close
      end
    end
  end
end