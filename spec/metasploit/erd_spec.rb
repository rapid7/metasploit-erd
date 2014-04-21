require 'spec_helper'

describe Metasploit::ERD do
  context 'CONSTANTS' do
    context 'VERSION' do
      subject(:version) do
        described_class::VERSION
      end

      it 'is Metasploit::ERD::Version.full' do
        expect(version).to eq(Metasploit::ERD::Version.full)
      end
    end
  end

  context 'namespace_entities' do
    subject(:namespace_entities) {
      described_class.namespace_entities(namespace_name)
    }

    #
    # lets
    #

    let(:other_namespace_name) {
      'OtherNamespace'
    }

    let(:namespace_name) {
      'Namespace'
    }

    #
    # Callbacks
    #

    before(:each) do
      stub_const(other_namespace_name, Module.new)
      stub_const(namespace_name, Module.new)

      expect(ActiveRecord::Base.direct_descendants).to be_empty
    end

    after(:each) do
      # `ActiveSupport::DescendantsTracker.clear` will not clear ActiveRecord::Base subclasses because
      # ActiveSupport::Dependencies is loaded
      ActiveRecord::Base.direct_descendants.clear
    end

    context 'with ActiveRecord::Base descendants' do
      let(:child_name) {
        'Child'
      }

      let(:childnamespace_name) {
        'ChildNamespace'
      }

      let(:grandchild_name) do
        'GrandChild'
      end

      let(:other_namespaced_child_name) {
        "#{other_namespace_name}::#{child_name}"
      }

      let(:other_namespaced_child) {
        other_namespaced_child_name.constantize
      }

      let(:namespaced_child) do
        namespaced_child_name.constantize
      end

      let(:namespaced_child_name) {
        "#{namespace_name}::#{child_name}"
      }

      let(:namespaced_child_namespace_name) {
        "#{namespace_name}::#{childnamespace_name}"
      }

      let(:namespaced_grandchild) {
        namespaced_grandchild_name.constantize
      }

      let(:namespaced_grandchild_name) {
        "#{namespaced_child_namespace_name}::#{grandchild_name}"
      }

      #
      # Callbacks
      #

      before(:each) do
        stub_const(other_namespaced_child_name, Class.new(ActiveRecord::Base))

        stub_const(namespaced_child_name, Class.new(ActiveRecord::Base))

        stub_const(namespaced_child_namespace_name, Module.new)
        stub_const(namespaced_grandchild_name, Class.new(ActiveRecord::Base))
      end

      it 'does not include entities from other namespaces' do
        expect(namespace_entities).not_to include(other_namespaced_child)
      end

      it 'includes direct children of the namespace' do
        expect(namespace_entities).to include(namespaced_child)
      end

      it 'includes indirect descendants of the namespace' do
        expect(namespace_entities).to include(namespaced_grandchild)
      end
    end

    context 'without ActiveRecord::Base descendants' do
      it { should be_empty }
    end
  end
end
