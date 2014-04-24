# Entity for Entity-Relationship Diagram that wraps a `Class<ActiveRecord::Base>` to assist with finding its
# {#class_set directly related classes}
class Metasploit::ERD::Entity::Class
  include Metasploit::ERD::Clusterable

  #
  # Attributes
  #

  attr_reader :klass

  # @!attribute [r] klass
  #   The class whose `belongs_to` associations should be followed to generate
  #   {#class_set set of Classes on which it depends}.
  #
  #   @return [Class<ActiveRecord::Base>]

  #
  # Instance Methods
  #

  # @param klass [Class<ActiveRecord::Base>]
  def initialize(klass)
    @klass = klass
  end

  # Returns all classes to which the {#klass} has a `belongs_to` association.  Only `belongs_to` associations are traced
  # because they have foreign keys and without the belongs_to associations the foreign keys would have no primary keys
  # to which to point.
  #
  # @param source [Class<ActiveRecord::Base>] an `ActiveRecord::Base` subclass.
  # @return [Set<Class<ActiveRecord::Base>>]
  def class_set
    reflections = klass.reflect_on_all_associations(:belongs_to)

    reflections.each_with_object(Set.new) { |reflection, set|
      relationship = Metasploit::ERD::Relationship.new(reflection)
      set.merge(relationship.class_set)
    }
  end

  # Cluster seeded with {#klass}.
  #
  # @return [Metasploit::ERD::Cluster]
  def cluster
    Metasploit::ERD::Cluster.new(klass)
  end

  # (see Metasploit::ERD::Clusterable#diagram)
  #
  # @example Generate ERD for a Class in directory
  #   klass = Klass
  #   entity = Metasploit::ERD::Entity::Class.new(klass)
  #   # will add default .png extension
  #   diagram = entity.diagram(directory: directory)
  #   diagram.create
  #
  # @option options [String] :basename ("<klass.name.underscore>.erd") The basename to use for the `:filename`
  #   option.
  # @option options [String] :title ("<klass.name> Namespace Entity-Relationship Diagram") Title for diagram.
  def diagram(options={})
    super_options = {
        basename: "#{klass.name.underscore}.erd",
        title: "#{klass} Entity-Relationship Diagram"
    }.merge(options)

    super(super_options)
  end
end
