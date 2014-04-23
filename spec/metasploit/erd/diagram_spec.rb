require 'spec_helper'

describe Metasploit::ERD::Diagram do
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

      context '[:indirect]' do
        subject(:indirect) {
          default_options[:indirect]
        }

        it 'should be INDIRECT' do
          expect(indirect).to eq(described_class::INDIRECT)
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

    context 'INDIRECT' do
      subject(:indirect) {
        described_class::INDIRECT
      }

      it { should be_false }
    end

    context 'INHERITANCE' do
      subject(:inheritance)  {
        described_class::INHERITANCE
      }

      it { should be_true }
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

      it { should be_true }
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