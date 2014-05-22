require "socket"

module RAMI
  class Listener
    attr_reader :sock, :data

    def initialize(host, port)
      begin
        @sock = TCPSocket.open(host, port)
      rescue
        nil
      end
    end

    def login(login)
      @sock.puts(login)
      @sock.recv(1000)
    end

    def run
      @data = @sock.recv(5000)
      unless @data.empty?
        yield if block_given?
      else
        @sock.close
      end
    end
  end
end
