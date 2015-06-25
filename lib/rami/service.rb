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
          thread
        end
      end

      private

      def thread
        $stdout.puts "#{Time.now} - service started"

        Thread.new do
          loop do
            break if Listener.sock.closed?
            Listener.run do
              data = Listener.data
              event = Event.new(data)

              unless event.nil?
                if event.cdr?
                  if event.passed?(event.source) || event.passed?(event.destination)
                    @db[@cfg['mongo_collection']].insert_one(event.fields)
                  end
                  $stdout.puts(data) if event.source == '0000'
                end
              end
            end
          end
        end.join

        $stdout.puts "#{Time.now} - connection closed"
        sleep(5)
        start
      end
    end
  end
end
