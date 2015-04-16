RSpec.describe Metasploit::ERD::Relationship do
  include_context 'ActiveRecord::Base connection'
  include_context 'ActiveRecord::Base.descendants cleaner'

  subject(:relationship) {
    described_class.new(association)
  }

  #
  # lets
  #

  let(:owner) {
    Class.new(ActiveRecord::Base)
  }

  let(:owner_name) {
    'Owner'
  }

  #
  # Callbacks
  #

  before(:each) do
    stub_const(owner_name, owner)
  end

  context '#class_set' do
    subject(:class_set) {
      relationship.class_set
    }

    context 'with polymorphic:' do
      context 'false' do
        let(:association) {
          owner.reflect_on_association(:klass)
        }

        let(:klass) {
          Class.new(ActiveRecord::Base)
        }

        let(:klass_name) {
          'Klass'
        }

        #
        # Callbacks
        #

        before(:each) do
          stub_const(klass_name, klass)

          owner.belongs_to :klass,
                           class_name: klass_name,
                           inverse_of: :owneres

          klass.has_many :owners,
                         class_name: 'Owner',
                         inverse_of: :klass

          ActiveRecord::Migration.verbose = false

          ActiveRecord::Migration.create_table :klasses do |t|
            t.timestamps
          end

          ActiveRecord::Migration.create_table :owners do |t|
            t.references :klass

            t.timestamps
          end
        end

        it { is_expected.to be_a Set }

        it 'includes association.klass' do
          expect(class_set).to include(association.klass)
        end
      end

      context 'true' do
        #
        # lets
        #

        let(:association) {
          owner.reflect_on_association(:thing)
        }

        let(:things) {
          owner_name = self.owner_name

          thing_names.collect { |class_name|
            klass = Class.new(ActiveRecord::Base) {
              has_many :owners,
                       as: :thing,
                       class_name: owner_name
            }

            stub_const(class_name, klass)
          }
        }

        let(:thing_names) {
          Array.new(2) { |n|
            "Thing#{n}"
          }
        }

        #
        # Callbacks
        #

        before(:each) do
          owner.belongs_to :thing,
                           polymorphic: true

          # ensure polymorphic target classes are created
          things

          ActiveRecord::Migration.verbose = false

          ActiveRecord::Migration.create_table :owners do |t|
            t.references :thing

            t.timestamp
          end

          things.each do |thing|
            ActiveRecord::Migration.create_table thing.table_name do |t|
              t.timestamp
            end
          end
        end

        it { is_expected.to be_a Set }

        it 'includes all classes that have has_many <inverse>, as: <reflection.name>' do
          expect(class_set).to eq(Set.new(things))
        end

        it 'calls #polymorphic_class_set' do
          expect(relationship).to receive(:polymorphic_class_set)

          class_set
        end
      end
    end
  end

  context '#polymorphic_class_set' do
    subject(:polymorphic_class_set) {
      relationship.send(:polymorphic_class_set)
    }

    #
    # Lets
    #

    let(:association) {
      owner.reflect_on_association(:first)
    }

    let(:group_names) {
      [
          'First',
          'Second'
      ]
    }

    let(:polymorphics_by_group_name) {
      owner_name = self.owner_name

      polymorphic_names_by_group_name.each_with_object({}) { |(group_name, polymorphic_names), hash|
        hash[group_name] = polymorphic_names.collect { |class_name|
          klass = Class.new(ActiveRecord::Base) {
            has_many :owners,
                     as: group_name.underscore.to_sym,
                     class_name: owner_name
          }

          stub_const(class_name, klass)
        }
      }
    }

    let(:polymorphic_names_by_group_name) {
      group_names.each_with_object({}) { |group_name, hash|
        hash[group_name] = Array.new(2) { |n|
          "#{group_name}Polymorphic#{n}"
        }
      }
    }

    #
    # Callbacks
    #

    before(:each) do
      group_names.each do |group_name|
        owner.belongs_to group_name.underscore.to_sym,
                         polymorphic: true
      end

      ActiveRecord::Migration.verbose = false

      ActiveRecord::Migration.create_table :owners do |t|
        group_names.each do |group_name|
          t.references group_name.underscore.to_sym
        end

        t.timestamp
      end

      polymorphics_by_group_name.each do |group_name, polymorphics|
        polymorphics.each do |klass|
          ActiveRecord::Migration.create_table klass.table_name do |t|
            t.timestamps
          end
        end
      end
    end

    it { is_expected.to be_a Set }

    context 'with has_many as: <association.name>' do
      it 'includes classes' do
        polymorphics_by_group_name['First'].each do |klass|
          expect(polymorphic_class_set).to include(klass)
        end
      end
    end

    context 'with has_many as: <not association.name>' do
      it 'does not include classes' do
        polymorphics_by_group_name['Second'].each do |klass|
          expect(polymorphic_class_set).not_to include(klass)
        end
      end
    end
  end
end