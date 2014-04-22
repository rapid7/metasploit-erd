require 'active_support/dependencies/autoload'

# Namespace for classes that function as Entities in Entity-Relationship diagrams, such as
# {Metasploit::ERD::Entity::Namespace namespace `Module`s}.
module Metasploit::ERD::Entity
  extend ActiveSupport::Autoload

  autoload :Namespace
end