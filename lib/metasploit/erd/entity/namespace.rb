# Entity for a namespace with a given {#namespace_name name}.
class Metasploit::ERD::Entity::Namespace
  include Metasploit::ERD::Clusterable

  #
  # Attributes
  #

  attr_reader :namespace_name

  # @!attribute [r] namespace_name
  #   The `Module#name` of a namespace module for a collection of `Class<ActiveRecord::Base>`
  #
  #   @return [String]

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
      klass.module_parents.any? { |parent|
        parent.name == namespace_name
      }
    }
  end

  # Cluster seeded with all {#classes} in this namespace.
  #
  # @return [Metasploit::ERD::Cluster]
  def cluster
    Metasploit::ERD::Cluster.new(*classes)
  end

  # (see Metasploit::ERD::Clusterable#diagram)
  #
  # @example Generate ERD for namespace in directory
  #   entity = Metasploit::ERD::Entity::Namespace.new('Nested::Namespace')
  #   # will add default .png extension
  #   diagram = entity.diagram(directory: directory)
  #   diagram.create
  #
  # @option options [String] :basename ("<namespace_name.underscore>.erd") The basename to use for the `:filename`
  #   option.
  # @option options [String] :title ("<namespace_name> Namespace Entity-Relationship Diagram") Title for diagram.
  def diagram(options={})
    super_options = {
        basename: "#{namespace_name.underscore}.erd",
        title: "#{namespace_name} Namespace Entity-Relationship Diagram"
    }.merge(options)

    super(super_options)
  end
end
