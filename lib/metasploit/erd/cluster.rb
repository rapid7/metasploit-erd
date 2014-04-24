# A cluster of `Class<ActiveRecord::Base>` that are connected by `belongs_to` associations so that all foreign keys are
# paired with their appropriate primary keys.
class Metasploit::ERD::Cluster
  #
  # Instance Methods
  #

  # @param roots [Array<Class<ActiveRecord::Base>>] starting `ActiveRecord::Base` subclasses to seed {#class_set}.
  def initialize(*roots)
    class_queue.concat(roots)
  end

  # Clases that are reachable through `belongs_to` associations on classes passed as `roots` to {#initialize}.
  #
  # @return [Set<Class<ActiveRecord::Base>>]
  def class_set
    until class_queue.empty?
      klass = class_queue.pop
      # add immediately to visited set in case there are recursive associations
      visited_class_set.add klass

      class_entity = Metasploit::ERD::Entity::Class.new(klass)

      class_entity.class_set.each do |klass|
        unless visited_class_set.include? klass
          class_queue << klass
        end
      end

      superclass = klass.superclass

      unless superclass == ActiveRecord::Base || visited_class_set.include?(superclass)
        class_queue << superclass
      end
    end

    visited_class_set
  end

  private

  def class_queue
    @class_queue ||= []
  end

  def visited_class_set
    @visited_class_set ||= Set.new
  end
end
