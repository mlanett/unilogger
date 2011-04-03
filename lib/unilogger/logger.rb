require "fiber" unless RUBY_VERSION =~ /^1\.8/
require "json"
require "logger"

module Unilogger
  
  # Adds pid and timestamp to each log entry.
  # Implements IO API (<<) which is equivalent to info()
  # Implements Logger API (debug, info, warn, error, fatal)
  class Logger
    
    include ::Logger::Severity
    attr :level, true
    attr :emitters
    
    def initialize( level = DEBUG, emitters = [] )
      @level    = level
      @emitters = emitters.dup
    end
    
    def emit( details, message, options )
      @emitters.each { |e| e.emit( details, message, options ) }
    end
    
    def <<( message )
      details = { :pri_sym => :INFO, :pri_num => Logger::Severity::INFO, :pid => Process.pid, :time => Time.now }
      self.emit( details, message, nil )
    end
    
    # level methods may take 0..2 arguments, or a block parameter
    # argument 1 or the block is stringified as the primary message
    # argument 2 is a set of named parameters (e.g. a hash)
    ::Logger::Severity.constants.each do |const|
      
      # const e.g. INFO; label e.g. info; priority e.g. 1
      label = const.to_s.downcase.to_sym
      priority = ::Logger::Severity.const_get(const)
      
      # def info( message, options = {}, &block ) ...
      define_method( label ) do |*args,&block|
        raise ArgumentError if args.size > 2
        if @level <= priority then
          details = { :pri_sym => const, :pri_num => priority, :pid => Process.pid, :time => Time.now, :fiber => 0 } if RUBY_VERSION =~ /^1\.8/
          details = { :pri_sym => const, :pri_num => priority, :pid => Process.pid, :time => Time.now, :fiber => Fiber.current.object_id } unless RUBY_VERSION =~ /^1\.8/
          case args.size
          when 0
            message = block.call if block
            options = nil
          when 1
            message = args.first
            options = nil
          when 2
            message = args.first
            options = args.last
          end
          self.emit( details, message.to_s, options )
        end
        @level <= priority
      end # info()
      
      # def info?
      define_method( "#{label}?".to_sym ) do
        @level <= priority
      end # info?
      
    end # each
    
    def as_json
      { :level => @level, :emitters => as_json_helper(@emitters) }
    end
    
    def as_json_helper( it )
      if it.nil? then
        it
      elsif it.respond_to?(:as_json) then
        it.as_json
      elsif it.kind_of?(Hash) then
        it.inject({}) { |a,i| a[i.first] = as_json_helper(i.last); a }
      elsif it.kind_of?(Array) || it.kind_of?(Enumerable)
        it.map { |i| as_json_helper(i) }
      else
        it
      end
    end
    
    def to_json
      as_json.to_json
    end
    
  end # Logger

end # Unilogger
