require 'spec_helper'
require 'rails_helper'

describe Order do
  it { is_expected.to have_many(:line_items).dependent :destroy }
  
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_presence_of :email }
  
  it "should only have the given value for pay type" do
   order = Order.new
   expect(order).to validate_inclusion_of(:pay_type).in_array(["Check", "Credit Card", "Purchase Order"])
  end
end
