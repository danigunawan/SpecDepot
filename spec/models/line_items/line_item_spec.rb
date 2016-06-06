require 'rails_helper'
require 'spec_helper'

describe LineItem do
  it {is_expected.to belong_to :product}
  it {is_expected.to belong_to :order}
  it {is_expected.to belong_to :cart}
  
  it "should return total price of line items" do
    line_item1 = FactoryGirl.create(:line_item, :quantity => 3)

    total = line_item1.product.price * line_item1.quantity
    expect(total).to eq(108)
  end
end