# Entity for Entity-Relationship Diagram that wraps an `Class<ActiveRecord::Base>` to assist with finding its
# relationships.
class Metasploit::ERD::Entity::Class
  #
  # Attributes
  #

  # @!attribute klass
  #   The class whose `belongs_to` associations should be followed to generate
  #   {#class_set set of Classes on which it depends}
  #
  #   @return [Class<ActiveRecord::Base>]
  attr_reader :klass

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
end
