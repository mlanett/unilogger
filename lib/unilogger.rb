require "unilogger/builder"
require "unilogger/log_file_emitter"
require "unilogger/logger"

module Unilogger
  
  class << self
    def logger( options )
      Builder.build( options )
    end
  end
  
end
