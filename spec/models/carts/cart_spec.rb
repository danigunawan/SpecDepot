require 'rails_helper'
require 'spec_helper'

describe Cart do
  it { is_expected.to have_many(:line_items).dependent :destroy }
    before(:each) do
      @line_item1 = FactoryGirl.create(:line_item)
      @cart = Cart.create
      @itemMade = @cart.add_product(@line_item1.product_id)   
    end
    
    it "should add product" do 
      expect(@cart.line_items).not_to be nil
    end
  
    it "should decrement line item quantity" do      
      cartTest = FactoryGirl.create(:cart, line_items: [FactoryGirl.create(:line_item, quantity: 2)])
      expect(cartTest.decrement_line_item_quantity(3).quantity).to eq(1)
    end
    
    it "should destroy line item" do      
      cartTest = FactoryGirl.create(:cart, line_items: [FactoryGirl.create(:line_item, quantity: 1)])
      expect(LineItem.exists?(cartTest.decrement_line_item_quantity(3).id)).to be false
    end
  
    it "should solve total price" do
      cartTest = FactoryGirl.create(:cart, line_items: [FactoryGirl.create(:line_item, quantity: 2)])
      expect(cartTest.total_price).to eq(72)
    end
end