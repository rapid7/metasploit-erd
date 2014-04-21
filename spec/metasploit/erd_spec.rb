require 'spec_helper'

describe Metasploit::Erd do
  it 'should have a version number' do
    Metasploit::Erd::VERSION.should_not be_nil
  end

  it 'should do something useful' do
    false.should eq(true)
  end
end
