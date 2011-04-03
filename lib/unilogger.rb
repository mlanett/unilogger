require "unilogger/builder"
require "unilogger/log_file_emitter"
require "unilogger/logger"

module Unilogger
  
  class << self
    def build( options )
      it = Builder.build( options )
      it.debug "Hello, world!"
      return it
    end
  end
  
end
