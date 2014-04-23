require 'rails_erd/diagram/graphviz'

# A diagram specialized with default options that work well with {Metasploit::ERD::Domain#domain}.
class Metasploit::ERD::Diagram < RailsERD::Diagram::Graphviz
  #
  # CONSTANTS
  #

  # Enable all attributes
  ATTRIBUTES = [
      :content,
      :foreign_keys,
      :primary_keys,
      :timestamps
  ]

  # Only show direct relationships because anything indirect can be found by tracing the direct arrows and only showing
  # direct relationships cuts down on cluster
  INDIRECT = false

  # Show inheritance for Single Table Inheritance
  INHERITANCE = true

  # Use crowsfoot notation since its what metasploit uses for manually drawn and graffle diagrams.
  NOTATION = :crowsfoot

  # Show polymorphic association connections as they are traced by
  # {Metasploit::ERD::Relationship#polymorphic_class_set}.
  POLYMORPHISM = true

  # Default options for {#initialize}
  DEFAULT_OPTIONS = {
      attributes: ATTRIBUTES,
      indirect: INDIRECT,
      inheritance: INHERITANCE,
      notation: NOTATION,
      polymorphism: POLYMORPHISM
  }

  #
  # Instance Methods
  #

  # @param domain [RailsERD::Domain] domain to diagram
  # @param options [Hash{Symbol => Object}] options controlling what to include from domain and how to render diagram.
  #   Defaults to {DEFAULT_OPTIONS}.
  def initialize(domain, options={})
    super_options = DEFAULT_OPTIONS.merge(options)

    super(domain, super_options)
  end
end