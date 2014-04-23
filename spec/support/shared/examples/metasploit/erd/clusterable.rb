shared_examples_for 'Metasploit::ERD::Clusterable' do
  context '#diagram' do
    subject(:diagram) {
      entity.diagram
    }

    it { should be_a Metasploit::ERD::Diagram }

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