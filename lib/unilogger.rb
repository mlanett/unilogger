module Unilogger
  # nop
end

require "unilogger/line_logger"

STDERR.puts "[#{Process.pid}] unilogger: initialized"
