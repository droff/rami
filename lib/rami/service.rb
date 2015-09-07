module RAMI
  class Service
    class << self
      attr_reader :cfg

      def init(config_file)
        @cfg = Config.load(config_file)
        @db = Mongo::Client.new("mongodb://#{@cfg['mongo_host']}/#{@cfg['mongo_db']}")
        Mongo::Logger.logger.level = ::Logger::FATAL

        $0 = @cfg['name']
        Daemon.start(fork, @cfg['pidfile'], @cfg['log_file'])
      end

      def start
        Listener.init(@cfg['host'], @cfg['port'])
        if Listener.sock
          Listener.auth(@cfg['username'], @cfg['secret'])
          $stdout.puts "#{Time.now} - connection started"
          thread
        end
      end

      private

      def thread
        Thread.new do |t|
          loop do
            break if Listener.sock.closed?

            Listener.run do
              data = Listener.data
              event = Event.new(data)
              event.insert_data do
                @db[@cfg['mongo_collection']].insert_one(event.fields)
              end
            end
          end
        end.join

        restart
      end

      def restart
        $stdout.puts "#{Time.now} - connection closed"
        sleep(15)
        start
      end
    end
  end
end
