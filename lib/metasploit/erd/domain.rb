require 'rails_erd/domain'

# Adds {#domain} to any class that supports a `cluster` method
module Metasploit::ERD::Domain
  # Domain restricted to `#cluster` {Metasploit::ERD::Cluster#class_set}
  #
  # @return [RailsERD::Domain]
  def domain
    RailsERD::Domain.new(
        cluster.class_set,
        # don't warn about missing entities in domain since only belongs_to associations are traced in the cluster and
        # not has_many associations.
        warn: false
    )
  end
end