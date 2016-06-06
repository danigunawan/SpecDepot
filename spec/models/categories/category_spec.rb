require 'spec_helper'
require 'rails_helper'

describe Category do
  let(:category1) { build(:category) }
  
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to have_many :products}
  it { expect(category1).to be_valid }
end