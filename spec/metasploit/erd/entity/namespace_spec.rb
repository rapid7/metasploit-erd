RSpec.describe Metasploit::ERD::Entity::Namespace do
  include_context 'ActiveRecord::Base.descendants cleaner'

  subject(:namespace_entity) {
    described_class.new(namespace_name)
  }

  let(:namespace_name) {
    'Namespace'
  }

  it_should_behave_like 'Metasploit::ERD::Clusterable' do
    let(:entity) {
      described_class.new('Dummy')
    }
  end

  context '#classes' do
    subject(:namespace_entities) {
      namespace_entity.classes
    }

    #
    # lets
    #

    let(:other_namespace_name) {
      'OtherNamespace'
    }

    #
    # Callbacks
    #

    before(:each) do
      stub_const(other_namespace_name, Module.new)
      stub_const(namespace_name, Module.new)
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

  context '#cluster' do
    subject(:cluster) {
      namespace_entity.cluster
    }

    it 'created a Metasploit::ERD::Cluster containing #classes' do
      classes = Array.new(2) { |n|
        double("Class#{n}")
      }

      expect(namespace_entity).to receive(:classes).and_return(classes)
      expect(Metasploit::ERD::Cluster).to receive(:new).with(*classes)

      cluster
    end
  end
end