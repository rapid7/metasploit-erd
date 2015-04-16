RSpec.describe Metasploit::ERD do
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
end
