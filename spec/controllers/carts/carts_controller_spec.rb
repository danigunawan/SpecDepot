require 'spec_helper'
require 'rails_helper'

describe CartsController do
  
  let!(:user1){FactoryGirl.create(:user)}
  let!(:cart1){FactoryGirl.create(:cart)}
  
  context "if logged in" do
    describe "get #index" do
      before(:each) do 
          sign_in user1
          get :index
      end
    
      it "returns all carts" do
        cartList = Cart.all
        expect(assigns(:carts)).to eq(cartList)
      end
    end
  end
  
  context "if not logged in" do
    describe "get #index" do
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to user_session_path
      end
    end
  end
  
  describe "delete #destroy" do
    it "destroys cart" do
      delete :destroy, {:id => cart1.id}, {:cart_id => cart1.id}
      expect(Cart.exists?(cart1.id)).to be false
    end
  end
  
end