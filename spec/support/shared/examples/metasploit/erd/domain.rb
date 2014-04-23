shared_examples_for 'Metasploit::ERD::Domain' do
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