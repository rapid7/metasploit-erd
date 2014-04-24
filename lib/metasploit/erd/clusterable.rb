require 'rails_erd/domain'

# Adds {#domain} and {#diagram} to any class that responds to `#cluster`.
module Metasploit::ERD::Clusterable
  # Diagram using {#domain}.
  #
  # @param options (see Metasploit::ERD::Diagram#initialize)
  # @option options (see Metasploit::ERD::Diagram#initialize)
  # @option options [String] :basename The basename to use for the `:filename` option.  Only use only if not `nil`.
  # @option options [String] :diretory (Dir.pwd) The directory to use for the `:filename` options.  Only used if
  #   `:basename` is not `nil`.
  # @return [Metasploit::ERD:Diagram]
  def diagram(options={})
    merged_options = options.except(:basename, :directory)
    basename = options[:basename]

    if basename
      directory = options[:directory]
      # separate line so coverage can show this case is tested
      directory ||= Dir.pwd

      merged_options[:filename] = File.join(directory, basename)
    end

    Metasploit::ERD::Diagram.new(domain, merged_options)
  end

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