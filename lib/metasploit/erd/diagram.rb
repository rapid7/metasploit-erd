require 'rails_erd/diagram/graphviz'

# A diagram specialized with default options that work well with {Metasploit::ERD::Clusterable#domain}.
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

  # File type that work for embedding in web pages and is lossless.
  FILETYPE = :png

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
      filetype: FILETYPE,
      indirect: INDIRECT,
      inheritance: INHERITANCE,
      notation: NOTATION,
      polymorphism: POLYMORPHISM
  }

  #
  # Callbacks
  #

  # Callbacks are not inherited normally, so this emulates inheriting
  callbacks.merge!(superclass.send(:callbacks))

  # super() for save
  supersave = callbacks[:save]

  # Automatically create parent directory if it does not exist.
  save {
    parent = Pathname.new(filename).parent

    unless parent.directory?
      parent.mkpath
    end

    instance_eval &supersave
  }

  #
  # Instance Methods
  #

  # @param domain [RailsERD::Domain] domain to diagram
  # @param options [Hash{Symbol => Object}] options controlling what to include from domain and how to render diagram.
  #   Defaults to {Metasploit::ERD::Diagram::DEFAULT_OPTIONS}.
  # @option options [Array<Symbol>] :attributes (ATTRIBUTES) attributes of each entity (table) to include in the
  #   diagram.
  # @option options [String, Symbol] :filetype (FILETYPE) the file type of the generated diagram.  Supported formats
  #   depend on formats supported by graphviz installation.
  # @option options [Boolean] :indirect (INDIRECT) Whether to include indirect (`has_many through:`) relationships.
  # @option options [Boolean] :inheritance (INHERITANCE) Whether to include Single Table Inheritance (STI) subclass
  #   entities.
  # @option options [Symbol] :notation (NOTATION) The cardinality notation to be used.  Refer to RailsERD
  #   documentation for availble notations.
  # @option options [:horizontal, :vertical] :orientation (:horizontal) The directory of the hierarchy of entities.
  # @option options [Boolean] :polymorphism (POLYMORPHISM) Whether to include abstract or polymorphic pseudo-entities.
  # @option options [String] :title Title for diagram.
  def initialize(domain, options={})
    super_options = DEFAULT_OPTIONS.merge(options)

    super(domain, super_options)
  end
end