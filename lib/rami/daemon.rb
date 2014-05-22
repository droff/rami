module RAMI
  class Daemon
    def self.start(pid, pidfile, outfile, errfile)
      unless pid.nil?
        write pid, pidfile
        exit
      else
        redirect outfile, errfile
      end
    end

    def self.write(pid, pidfile)
      File.open(pidfile, "w") { |f| f.write(pid) }
    end

    def self.kill(pid)
      Process.kill("HUP", pid)
      true
    end

     def self.redirect(outfile, errfile)
       $stdin.reopen '/dev/null'
       out = File.new outfile, "a"
       err = File.new errfile, "a"
       $stdout.reopen out
       $stderr.reopen err
       $stdout.sync = $stderr.sync = true
     end
  end
end
