require "logger"
require "redis"
require "redis/namespace"

module Unilogger
  
  class RedisEmitter
    
    class << self
      def build( options )
      end
    end
    
    def emit( details, message, options )
    end
    
  end # RedisEmitter

end # Unilogger
