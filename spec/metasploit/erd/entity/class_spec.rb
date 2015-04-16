require 'spec_helper'

describe Metasploit::ERD::Entity::Class do
  include_context 'ActiveRecord::Base.descendants cleaner'

  subject(:class_entity) {
    described_class.new(klass)
  }

  #
  # lets
  #

  let(:klass) {
    Class.new(ActiveRecord::Base)
  }

  let(:klass_name) do
    'Klass'
  end

  #
  # Callbacks
  #

  before(:each) do
    stub_const(klass_name, klass)
  end

  it_should_behave_like 'Metasploit::ERD::Clusterable' do
    let(:entity) {
      described_class.new(Dummy::Widget)
    }
  end

  context '#class_set' do
    include_context 'ActiveRecord::Base connection'

    subject(:class_set) do
      class_entity.class_set
    end

    context 'with belongs_to associations' do
      context 'with same class twice' do
        #
        # lets
        #

        let(:target_name) do
          'Target'
        end

        let(:target) do
          Class.new(ActiveRecord::Base)
        end

        #
        # Callbacks
        #

        before(:each) do
          target_name = self.target_name

          stub_const(target_name, target)

          klass.class_eval do
            #
            # Associations
            #

            # @!attribute first_target
            #   @return [Target]
            belongs_to :first_target,
                       class_name: target_name,
                       inverse_of: :first_klasses

            # @!attribute second_target
            #   @return [Target]
            belongs_to :second_target,
                       class_name: target_name,
                       inverse_of: :second_klasses
          end

          klass_name = self.klass_name

          target.class_eval do
            #
            # Associations
            #

            # @!attribute first_klasses
            #   @return [ActiveRecord::Relation<Klass>]
            has_many :first_klasses,
                     class_name: klass_name,
                     inverse_of: :first_target

            # @!attribute second_klasses
            #   @return [ActiveRecord::Relation<Klass>]
            has_many :second_klasses,
                     class_name: klass_name,
                     inverse_of: :second_target
          end

          ActiveRecord::Migration.verbose = false

          ActiveRecord::Migration.create_table :targets do |t|
            t.timestamps
          end

          ActiveRecord::Migration.create_table :klasses do |t|
            t.references :first_target
            t.references :second_target

            t.timestamps
          end
        end

        it 'includes class once' do
          expect(class_set.length).to eq(1)
          expect(class_set).to include(target)
        end
      end

      context 'with has_many associations' do
        let(:belongs_to_target) do
          Class.new(ActiveRecord::Base)
        end

        let(:belongs_to_target_name) do
          'BelongsToTarget'
        end

        let(:has_many_target) do
          Class.new(ActiveRecord::Base)
        end

        let(:has_many_target_name) do
          'HasManyTarget'
        end

        before(:each) do
          belongs_to_target_name = self.belongs_to_target_name
          klass_name = self.klass_name
          has_many_target_name = self.has_many_target_name

          stub_const(belongs_to_target_name, belongs_to_target)
          stub_const(has_many_target_name, has_many_target)

          belongs_to_target.class_eval do
            #
            # Associations
            #

            # @!attribute klasses
            #   @return [ActiveRecord::Relation<Klass>]
            has_many :klasses,
                     class_name: klass_name,
                     inverse_of: :belongs_to_target
          end

          has_many_target.class_eval do
            #
            # Associations
            #

            # @!attribute klass
            #   @return [Klass]
            belongs_to :klass,
                       class_name: klass_name,
                       inverse_of: :has_many_targets
          end

          klass.class_eval do
            #
            # Associations
            #

            # @!attribute belongs_to_target
            #   @return [BelongsToTarget]
            belongs_to :belongs_to_target,
                       class_name: belongs_to_target_name,
                       inverse_of: :klasses

            # @!attribute has_many_targets
            #   @return [HasManyTarget]
            has_many :has_many_target,
                     class_name: has_many_target_name,
                     inverse_of: :klass
          end

          ActiveRecord::Migration.verbose = false

          ActiveRecord::Migration.create_table :belongs_to_targets do |t|
            t.timestamps
          end

          ActiveRecord::Migration.create_table :klass do |t|
            t.references :belongs_to_target

            t.timestamps
          end

          ActiveRecord::Migration.create_table :has_many_targets do |t|
            t.references :klass

            t.timestamps
          end
        end

        it 'includes belongs_to target classes' do
          expect(class_set).to include(belongs_to_target)
        end

        it 'does not include has_many target classes' do
          expect(class_set).not_to include(has_many_target)
        end
      end
    end

    context 'without belongs_to associations' do
      it { should be_empty }
    end
  end

  context '#cluster' do
    subject(:cluster) {
      class_entity.cluster
    }

    it 'creates a Metasploit::ERD::Cluster containing #klass' do
      expect(Metasploit::ERD::Cluster).to receive(:new).with(klass)

      cluster
    end
  end
end