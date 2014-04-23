# Entity for a namespace with a given {#namespace_name name}.
class Metasploit::ERD::Entity::Namespace
  #
  # Attributes
  #

  # @!attribute namespace_name
  #   The `Module#name` of a namespace module for a collection of `Class<ActiveRecord::Base>`
  #
  #   @return [String]
  attr_reader :namespace_name

  #
  # Instance Methods
  #

  # @param namespace_name [String]
  def initialize(namespace_name)
    @namespace_name = namespace_name
  end

  # @note Caller must load all `ActiveRecord::Base` descendants that should be in the search domain.
  #
  # The entities in the namespace with `namespace_name`.
  #
  # @param namespace_name [String] The `Module#name` of the `Class` or `Module` that is the namespace for a collection
  #   of `ActiveRecord::Base` descendants.
  # @return [Array<Class<ActiveRecord::Base>
  def classes
    ActiveRecord::Base.descendants.select { |klass|
      klass.parents.any? { |parent|
        parent.name == namespace_name
      }
    }
  end
end