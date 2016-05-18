require 'spec_helper'
describe 'pe_split_ha_aws' do

  context 'with default values for all parameters' do
    it { should contain_class('pe_split_ha_aws') }
  end
end
