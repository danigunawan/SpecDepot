require 'spec_helper'
require 'rails_helper'

describe LineItemsController do
  let!(:user1) {FactoryGirl.create(:user)}
  
  context "if logged in" do
    before(:each) do
      sign_in user1
    end  
    
    describe "get #index" do 
      let!(:item1) {FactoryGirl.create(:line_item)}
      it "returns all line items" do 
        get :index
        itemTest = LineItem.find(item1.id)
        itemList = assigns(:line_items)

        itemList.each do |item|
          LineItem.columns.each do |column|
            expect(item.send(column.name)).to eq(itemTest.send(column.name))
          end
        end
      end
    end
    
    describe "post #create" do 
      let!(:product1){FactoryGirl.create(:product)}
      before(:each) do
        post :create, :product_id => product1.id
      end
      
      it "creates a new line item" do 
        itemMade = LineItem.find_by(product_id: product1.id)
        expect(assigns(:line_item)).to eq(itemMade)
      end
    end
    
    describe "post #decrement" do 
      let!(:product1){FactoryGirl.create(:product)}
      before(:each) do
        post :create, :product_id => product1.id
      end
      
      it "destroys line item" do
        lineItem = assigns(:line_item)  
        
        post :decrement, :id => 1    
        expect(LineItem.all.count).to eq(0)
      end
      
      it "decreases line item by 1" do
        post :create, :product_id => product1.id
        post :decrement, :id => 1    
        lineItem = assigns(:line_item)  
        expect(lineItem.quantity).to eq(1)
      end
    end
  end
  
  context "if not logged in" do
    it "redirects to sign in page" do
      get :index
      expect(response).to redirect_to user_session_path
    end
  end
end