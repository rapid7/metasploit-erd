RSpec.describe Metasploit::ERD::Diagram do
  subject(:diagram) {
    described_class.new(*arguments)
  }

  let(:arguments) {
    [
        domain
    ]
  }

  let(:domain) {
    RailsERD::Domain.new
  }

  it { should be_a RailsERD::Diagram::Graphviz }

  context 'CONSTANTS' do
    context 'ATTRIBUTES' do
      subject(:attributes) {
        described_class::ATTRIBUTES
      }

      it { should include :content }
      it { should include :foreign_keys }
      it { should include :primary_keys }
      it { should include :timestamps }
    end

    context 'DEFAULT_OPTIONS' do
      subject(:default_options) {
        described_class::DEFAULT_OPTIONS
      }

      context '[:attributes]' do
        subject(:attributes) {
          default_options[:attributes]
        }

        it 'should be ATTRIBUTES' do
          expect(attributes).to eq(described_class::ATTRIBUTES)
        end
      end

      context '[:filetype]' do
        subject(:filetype) {
          default_options[:filetype]
        }

        it 'should be FILETYPE' do
          expect(filetype).to eq(described_class::FILETYPE)
        end
      end

      context '[:indirect]' do
        subject(:indirect) {
          default_options[:indirect]
        }

        it 'should be INDIRECT' do
          expect(indirect).to eq(described_class::INDIRECT)
        end
      end

      context '[:inheritance]' do
        subject(:inheritance) {
          default_options[:inheritance]
        }

        it 'should be INHERITANCE' do
          expect(inheritance).to eq(described_class::INHERITANCE)
        end
      end

      context '[:notation]' do
        subject(:notation) {
          default_options[:notation]
        }

        it 'should be NOTATION' do
          expect(notation).to eq(described_class::NOTATION)
        end
      end

      context '[:polymorphism]' do
        subject(:polymorphism) {
          default_options[:polymorphism]
        }

        it 'should be POLYMORPHISM' do
          expect(polymorphism).to eq(described_class::POLYMORPHISM)
        end
      end
    end

    context 'FILETYPE' do
      subject(:filetype) {
        described_class::FILETYPE
      }

      it { should == :png }
    end

    context 'INDIRECT' do
      subject(:indirect) {
        described_class::INDIRECT
      }

      it { should eq(false) }
    end

    context 'INHERITANCE' do
      subject(:inheritance)  {
        described_class::INHERITANCE
      }

      it { should eq(true) }
    end

    context 'NOTATION' do
      subject(:notation) {
        described_class::NOTATION
      }

      it { should == :crowsfoot }
    end

    context 'POLYMORPHISM' do
      subject(:polymorphism) {
        described_class::POLYMORPHISM
      }

      it { should eq(true) }
    end
  end

  context 'callbacks' do
    subject(:callbacks) {
      described_class.send(:callbacks)
    }

    context '[:each_entity]' do
      subject(:each_entity) {
        callbacks[:each_entity]
      }

      it { should_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:each_entity]' do
        expect(each_entity).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:each_entity])
      end
    end

    context '[:each_relationship]' do
      subject(:each_relationship) {
        callbacks[:each_relationship]
      }

      it { should_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:each_relationship]' do
        expect(each_relationship).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:each_relationship])
      end
    end

    context '[:each_specialization]' do
      subject(:each_specialization) {
        callbacks[:each_specialization]
      }

      it { should_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:each_specialization]' do
        expect(each_specialization).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:each_specialization])
      end
    end

    context '[:save]' do
      subject(:save) {
        callbacks[:save]
      }

      it { should_not be_nil }

      it 'extends RailsERD::Diagram::Graphviz.callbacks[:save]' do
        expect(save).not_to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:save])
      end
    end

    context '[:setup]' do
      subject(:setup) {
        callbacks[:setup]
      }

      it { should_not be_nil }

      it 'uses RailsERD::Diagram::Graphviz.callbacks[:setup]' do
        expect(setup).to eq(RailsERD::Diagram::Graphviz.send(:callbacks)[:setup])
      end
    end
  end

  context '#initialize' do
    context 'with domain' do
      it 'uses first argument as domain' do
        expect(diagram.domain).to eq(arguments.first)
      end

      context 'with options' do
        let(:arguments) {
          super() + [options]
        }

        let(:options) {
          {
              key: :value
          }
        }

        it 'merges options with DEFAULT_OPTIONS' do
          expect(described_class::DEFAULT_OPTIONS).to receive(:merge).with(options).and_call_original

          diagram
        end
      end

      context 'without options' do
        it 'uses DEFAULT_OPTIONS as #options' do
          described_class::DEFAULT_OPTIONS.each do |key, value|
            expect(diagram.options[key]).to eq(value)
          end
        end
      end
    end
  end
end