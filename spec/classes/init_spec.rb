require 'spec_helper'
describe 'afs' do

  context 'with defaults for all parameters' do
    it { should contain_class('afs') }
  end
end
