$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# require before 'metasploit/erd' so coverage is shown for files required by 'metasploit/erd'
require 'simplecov'

require 'metasploit/erd'
