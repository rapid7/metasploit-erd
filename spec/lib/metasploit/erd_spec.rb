RSpec.describe Metasploit::ERD do
  context 'CONSTANTS' do
    context 'VERSION' do
      subject(:version) {
        described_class::VERSION
      }

      it 'is Metasploit::ERD::Version.full' do
        expect(version).to eq(Metasploit::ERD.version)
      end
    end
  end
  
end
