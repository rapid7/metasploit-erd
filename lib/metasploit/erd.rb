#
# Gems
#

require 'active_record'
require 'active_support/core_ext/module/introspection'

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
    # @note Caller must load all `ActiveRecord::Base` descendants that should be in the search domain.
    #
    # The entities in the namespace with `namespace_name`.
    #
    # @param namespace_name [String] The `Module#name` of the `Class` or `Module` that is the namespace for a collection
    #   of `ActiveRecord::Base` descendants.
    # @return [Array<ActiveRecord::Base>]
    def self.namespace_entities(namespace_name)
      ActiveRecord::Base.descendants.select { |klass|
        klass.parents.any? { |parent|
          parent.name == namespace_name
        }
      }
    end
  end
end
