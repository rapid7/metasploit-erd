RSpec.shared_examples_for 'Metasploit::ERD::Clusterable' do
  include_context 'ActiveRecord::Base connection'

  #
  # Methods
  #

  def migrate
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Migration.create_table :dummy_factories do |t|
      t.timestamps
    end

    ActiveRecord::Migration.create_table :dummy_widgets do |t|
      t.references :factory

      t.timestamps
    end
  end

  #
  # lets
  #

  let(:dummy_module) {
    Module.new do
      def self.table_name_prefix
        'dummy_'
      end
    end
  }

  let(:dummy_factory) {
    Class.new(ActiveRecord::Base) do
      has_many :widgets,
               class_name: 'Dummy::Widget',
               inverse_of: :factory
    end
  }

  let(:dummy_widget) {
    Class.new(ActiveRecord::Base) do
      belongs_to :factory,
                 class_name: 'Dummy::Factory',
                 inverse_of: :widgets
    end
  }

  #
  # Callbacks
  #

  before(:each) do
    migrate

    stub_const('Dummy', dummy_module)
    stub_const('Dummy::Factory', dummy_factory)
    stub_const('Dummy::Widget', dummy_widget)
  end

  context '#diagram' do
    subject(:diagram) {
      entity.diagram(*arguments)
    }

    let(:arguments) {
      []
    }

    it { should be_a Metasploit::ERD::Diagram }

    context 'Metasploit::ERD::Diagram#create' do
      subject(:create) {
        diagram.create
      }

      #
      # lets
      #

      let(:arguments) {
        [
            {
                directory: directory
            }
        ]
      }

      let(:directory) {
        spec_pathname.join('tmp')
      }

      let(:spec_pathname) {
        Pathname.new(__FILE__).parent.parent.parent.parent.parent.parent
      }

      #
      # Callbacks
      #

      before(:each) do
        if directory.exist?
          directory.rmtree
        end
      end

      after(:each) do
        directory.rmtree
      end

      context 'directory' do
        context 'with existing' do
          before(:each) do
            directory.mkpath
          end

          it 'returns path where diagram was written' do
            expect(create).to be_a String
          end
        end

        context 'without existing' do
          it 'creates directory' do
            expect {
              create
            }.to change(directory, :directory?).to(true)
          end

          it 'returns path where diagram was written' do
            expect(create).to be_a String
          end
        end
      end

    end

    context 'Metasploit::ERD::Diagram#domain' do
      subject(:domain) {
        diagram.domain
      }

      it 'is #domain' do
        entity_domain = entity.domain
        allow(entity).to receive(:domain).and_return(entity_domain)

        expect(domain).to eq(entity_domain)
      end
    end

    context 'Metasploit::ERD::Diagram#options' do
      subject(:options) {
        diagram.options
      }

      context 'with :basename' do
        let(:arguments) {
          [
              argument_options
          ]
        }

        let(:argument_options) {
          {
              basename: argument_basename
          }
        }

        context 'with nil' do
          let(:argument_basename) {
            nil
          }

          it 'is not retained' do
            expect(options).not_to have_key(:basename)
          end
        end

        context 'without nil' do
          let(:argument_basename) {
            'basename.extra.extension'
          }

          it 'is not retained' do
            expect(options).not_to have_key(:basename)
          end

          context '[:filename]' do
            subject(:filename) {
              options[:filename]
            }

            it 'ends with :basename' do
              expect(filename).to end_with(argument_basename)
            end
          end

          context '[:directory]' do
            let(:argument_options) {
              super().merge(
                  directory: argument_directory
              )
            }

            context 'with nil' do
              let(:argument_directory) {
                nil
              }

              it 'is not retained' do
                expect(options).not_to have_key(:directory)
              end

              context '[:filename]' do
                subject(:filename) {
                  options[:filename]
                }

                it 'uses Dir.pwd for the directory' do
                  expect(File.dirname(filename)).to eq(Dir.pwd)
                end
              end
            end

            context 'without nil' do
              let(:argument_directory) {
                '/a/directory'
              }

              it 'is not retained' do
                expect(options).not_to have_key(:directory)
              end

              context '[:filename]' do
                subject(:filename) {
                  options[:filename]
                }

                it 'uses :directory for the directory' do
                  expect(File.dirname(filename)).to eq(argument_directory)
                end
              end
            end
          end
        end
      end

      context '[:directory]' do
        it 'is not retained' do
          expect(options).not_to have_key(:directory)
        end
      end

      context '[:title]' do
        subject(:title) {
          options[:title]
        }

        it { should be_a String }
      end
    end
  end

  context '#domain' do
    subject(:domain) do
      entity.domain
    end

    it 'creates RailsERD::Domain from #cluster Metasploit::ERD::Cluster#class_set' do
      # ensures entity's class defined cluster
      cluster = entity.cluster
      class_set = cluster.class_set

      expect(entity).to receive(:cluster).and_return(cluster)
      expect(cluster).to receive(:class_set).and_return(class_set)
      expect(RailsERD::Domain).to receive(:new).with(
                                      class_set,
                                      hash_including(warn: false)
                                  )

      domain
    end
  end
end