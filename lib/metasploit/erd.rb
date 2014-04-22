#
# Standard Library
#

require 'set'

#
# Gems
#

require 'active_record'
require 'active_support/dependencies/autoload'

#
# Project
#

require "metasploit/erd/version"

# Shared namespace for metasploit gems; used in {https://github.com/rapid7/metasploit-concern metasploit-concern},
# {https://github.com/rapid7/metasploit-erd metasploit-erd},
# {https://github.com/rapid7/metasploit-framework metasploit-framework}, and
# {https://github.com/rapid7/metasploit-model metasploit-model}
module Metasploit
  # The namespace for this gem.
  module ERD
    extend ActiveSupport::Autoload

    autoload :Cluster
    autoload :Entity
    autoload :Relationship
  end
end
