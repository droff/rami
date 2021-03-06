module RAMI
  class Listener
    class << self
      attr_reader :sock, :data

      def init(host, port)
        begin
          @sock = TCPSocket.open(host, port)
        rescue
          nil
        end
      end

      def auth(username, secret)
        auth = "Action: login\nUsername: #{username}\nSecret: #{secret}\nEvent: on\n\n"

        @sock.puts(auth)
        @sock.recv(1000)
      end

      def run(&block)
        @data = @sock.recv(5000)
        if @data.empty?
          @sock.close
        else
          yield if block_given?
        end
      end
    end
  end
end
