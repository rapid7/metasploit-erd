# The relationship in an Entity-Relationship Diagram.  Modelled using an {#association} extracted from a
# `Class<ActiveRecord::Base>` using reflection.
class Metasploit::ERD::Relationship
  #
  # Attributes
  #

  attr_reader :association

  # @!attribute [r] association
  #   A `belongs_to` association.
  #
  #   @return [ActiveRecord::Associations::BelongsToAssociation]

  #
  # Instance Methods
  #

  # @param association [ActiveRecord::Associations::BelongsToAssociation]
  def initialize(association)
    @association = association
  end

  # Set of classes pointed to by this association.  Differs from `association.klass` as {#class_set} properly handles
  # polymorphic associations by finding all `Class<ActiveRecord::Base>` that `has_many <inverse>, as: <name>` and so
  # can fulfill `belongs_to <name>, polymorpic: true`.
  #
  # @return [Set<Class<ActiveRecord::Base>>]
  def class_set
    if association.options[:polymorphic]
      polymorphic_class_set
    else
      Set.new([association.klass])
    end
  end

  private

  # Finds the target classes for `belongs_to <name>, polymorphic: true`.
  #
  # @return [Set<Class<ActiveRecord::Base>>]
  def polymorphic_class_set
    name = association.name

    ActiveRecord::Base.descendants.each_with_object(Set.new) { |descendant, class_set|
      has_many_reflections = descendant.reflect_on_all_associations(:has_many)

      has_many_reflections.each do |has_many_reflection|
        as = has_many_reflection.options[:as]

        if as == name
          class_set.add descendant
        end
      end
    }
  end
end
