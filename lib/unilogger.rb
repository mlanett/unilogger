$:.push File.expand_path("..", __FILE__)

require "logger"
require "unilogger/logger"
require "unilogger/line_logger"
require "unilogger/stderr_emitter"

module Unilogger
  
  class << self
    def logger
      Logger.new( ::Logger::Severity::DEBUG, [ StderrEmitter.new ] )
    end
  end
  
end

STDERR.puts "[#{Process.pid}] unilogger: initialized"
