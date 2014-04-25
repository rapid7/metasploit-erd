require 'spec_helper'

describe Metasploit::ERD::Cluster do
  include_context 'ActiveRecord::Base connection'
  include_context 'ActiveRecord::Base.descendants cleaner'

  subject(:cluster) {
    described_class.new(*roots)
  }

  context '#class_set' do
    subject(:class_set) {
      cluster.class_set
    }

    context 'with roots' do
      context 'with cycle' do
        let(:roots) do
          A
        end

        #
        # Callbacks
        #

        before(:each) do
          a_class = Class.new(ActiveRecord::Base) {
            belongs_to :b,
                       class_name: 'B',
                       inverse_of: :as

            has_many :cs,
                     class_name: 'C',
                     inverse_of: :a
          }

          stub_const('A', a_class)

          ActiveRecord::Migration.verbose = false

          ActiveRecord::Migration.create_table :as do |t|
            t.references :b
          end

          b_class = Class.new(ActiveRecord::Base) {
            has_many :as,
                     class_name: 'A',
                     inverse_of: :b

            belongs_to :c,
                       class_name: 'C',
                       inverse_of: :bs

          }

          stub_const('B', b_class)

          ActiveRecord::Migration.create_table :bs do |t|
            t.references :c
          end

          c_class = Class.new(ActiveRecord::Base) {
            belongs_to :a,
                       class_name: 'A',
                       inverse_of: :cs

            has_many :bs,
                     class_name: 'B',
                     inverse_of: :c
          }

          stub_const('C', c_class)

          ActiveRecord::Migration.create_table :cs do |t|
            t.references :a
          end
        end

        it 'includes all classes in cycle' do
          expect(class_set).to include A
          expect(class_set).to include B
          expect(class_set).to include C
        end
      end

      context 'with superclasses' do
        #
        # lets
        #

        let(:subclass) {
          Class.new(superclass)
        }

        let(:superclass) {
          Class.new(ActiveRecord::Base)
        }

        #
        # Callbacks
        #

        before(:each) do
          stub_const('Superclass', superclass)
          stub_const('Subclass', subclass)

          ActiveRecord::Migration.verbose = false

          ActiveRecord::Migration.create_table superclass.table_name do |t|
            # type column for hold Class#name for Single Table Inheritance (STI)
            t.string :type, null: false
          end
        end

        context 'with subclass as root' do
          let(:roots) {
            [
                subclass
            ]
          }

          it 'includes subclass' do
            expect(class_set).to include(subclass)
          end

          it 'includes superclass' do
            expect(class_set).to include(superclass)
          end
        end

        context 'with superclass as root' do
          let(:roots) {
            [
                superclass
            ]
          }

          it 'includes superclass' do
            expect(class_set).to include(superclass)
          end

          it 'does not include subclasses because subclasses should not have additional foreign keys' do
            expect(class_set).not_to include(subclass)
          end
        end
      end
    end

    context 'without roots' do
      let(:roots) do
        []
      end

      it { should be_a Set }
      it { should be_empty }
    end
  end
end