module Bane

  class Launcher

    def initialize(servers, logger = $stderr)
      @servers = servers
      @servers.each { |server| server.stdlog = logger }
      begin_self_pipe
      handle_sigint
    end

    def start
      @servers.each { |server| server.start }
    end

    def join
      @servers.each { |server| server.join }
    end

    def stop
      @servers.each { |server| server.stop }
    end

    private

    def begin_self_pipe
      p_read, @p_write = IO.pipe
      Thread.start(self, p_read) do |l, pr|
        pr.read # this will block until write end of pipe is closed
        pr.close
        l.stop
        exit
      end
    end

    def handle_sigint
      trap("SIGINT") {  @p_write.close }
    end

  end
  
end
