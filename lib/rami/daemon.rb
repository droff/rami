module RAMI
  class Daemon
    def self.start(pid, pid_file, log_file)
      if pid
        init_pid(pid, pid_file)
        init_signals
        exit
      else
        logging(log_file)
      end
    end

    def self.kill(pid)
      Process.kill('HUP', pid)
      true
    end

    private

    def self.init_pid(pid, pid_file)
      File.open(pid_file, 'w') { |f| f.write(pid) }
    end

    def self.logging(log_file)
      $stdin.reopen('/dev/null')
      log = File.new(log_file, 'a')
      $stdout.reopen(log)
      $stdout.sync = true
    end

    def self.init_signals
      %w(HUP INT QUIT).each do |name|
        Signal.trap(name) { $stdout.puts(name); exit }
      end
    end
  end
end
