#!/usr/bin/env ruby

root = File.expand_path( "../..", __FILE__ )
$: << root + "/lib"
require "unilogger"

logger = Unilogger::Builder.build :root => root

logger.debug "Starting."
logger.info  "started", :root => root
logger.warn  "nothing to do"
logger.error "end of file"
logger.fatal "exiting"
