require 'socket'

server = TCPServer.new(2202)
while true
  Thread.new do
    while cmd = gets.chomp
      puts "[!]CMD: #{cmd}"
      exit if cmd == '/q'
    end
  end

  Thread.new(server.accept) do |client|
    puts "[!]CONNECTED: #{client.inspect}"

    Thread.new do
      while client
        client.puts (0..100).map {('a'..'z').to_a[rand(26)]}.join + "\n\n"
        puts "sent"
        sleep 1
      end
    end

    Thread.new do
      while line = client.recv(100)
        puts "\t[-]LINE: #{line.length}, #{line.inspect}"
        if self.status == "sleep"
          self.kill
        end
      end
    end
  end
end
