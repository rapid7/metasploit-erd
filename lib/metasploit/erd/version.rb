module Metasploit
  module ERD
    # Holds components of {VERSION} as defined by {http://semver.org/spec/v2.0.0.html semantic versioning v2.0.0}.
    module Version
      #
      # CONSTANTS
      #

      # The major version number.
      MAJOR = 2
      # The minor version number, scoped to the {MAJOR} version number.
      MINOR = 0
      # The patch version number, scoped to the {MAJOR} and {MINOR} version numbers.
      PATCH = 0
      # The prerelease branch
      PRERELEASE = 'rails-upgrade'

      #
      # Module Methods
      #

      # The full version string, including the {Metasploit::ERD::Version::MAJOR},
      # {Metasploit::ERD::Version::MINOR}, {Metasploit::ERD::Version::PATCH}, and optionally, the
      # `Metasploit::ERD::Version::PRERELEASE` in the
      # {http://semver.org/spec/v2.0.0.html semantic versioning v2.0.0} format.
      #
      # @return [String] '{Metasploit::ERD::Version::MAJOR}.{Metasploit::ERD::Version::MINOR}.{Metasploit::ERD::Version::PATCH}'
      #   on master. '{Metasploit::ERD::Version::MAJOR}.{Metasploit::ERD::Version::MINOR}.{Metasploit::ERD::Version::PATCH}-PRERELEASE'
      #   on any branch other than master.
      def self.full
        version = "#{MAJOR}.#{MINOR}.#{PATCH}"

        if defined? PRERELEASE
          version = "#{version}-#{PRERELEASE}"
        end

        version
      end

      # The full gem version string, including the {Metasploit::ERD::Version::MAJOR},
      # {Metasploit::ERD::Version::MINOR}, {Metasploit::ERD::Version::PATCH}, and optionally, the
      # `Metasploit::ERD::Version::PRERELEASE` in the
      # {http://guides.rubygems.org/specification-reference/#version RubyGems versioning} format.
      #
      # @return [String] '{Metasploit::ERD::Version::MAJOR}.{Metasploit::ERD::Version::MINOR}.{Metasploit::ERD::Version::PATCH}'
      #   on master.  '{Metasploit::ERD::Version::MAJOR}.{Metasploit::ERD::Version::MINOR}.{Metasploit::ERD::Version::PATCH}.PRERELEASE'
      #   on any branch other than master.
      def self.gem
        full.gsub('-', '.pre.')
      end
    end

    # (see Version.gem)
    GEM_VERSION = Version.gem

    # (see Version.full)
    VERSION = Version.full
  end
end
