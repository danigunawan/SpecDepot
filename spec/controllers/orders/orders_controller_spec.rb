require 'spec_helper'
require 'rails_helper'

describe OrdersController do
  let!(:user1) {FactoryGirl.create(:user)}
  
  context "if logged in" do
    let!(:order1) {FactoryGirl.create(:order)}
    let!(:order2) {FactoryGirl.create(:order, :name => "Fred")}
    let!(:order3) {FactoryGirl.create(:order, :name => "Jack")}
    
    before(:each) do 
      sign_in user1
    end
    
    describe "GET #index" do
      before(:each) do 
        get :index
      end
      
      it "returns all orders ordered by name and id" do
        array = [order1,order2,order3].sort_by{|order| [order.name.downcase, order.id]}
        orders = assigns(:orders)
        (0..2).each do |n|
          expect(orders[n].name).to eq(array[n].name)
        end
      end
    end
  
    describe "GET #show" do
      before(:each) do 
        get :show, :id => order1.id
      end
      
      it "displays order" do 
        expect(Order.exists?(order1.id)).to eq(true)
        expect(assigns(:order)).to eq(order1)
      end
    end

    describe "GET #edit" do
      before(:each) do 
        get :edit, :id => order1.id
      end
      
      it "checks if order exists" do
        expect(Order.exists?(order1.id))
      end
      
      it "renders edit order template" do
        expect(response).to render_template("edit")
      end
    end

    describe "PUT #update" do
      before(:each) do 
        orderAttributes = FactoryGirl.attributes_for(:order, :name => "Fred", :address => "Another Address", 
                                                     :email => "bla@bla.com", :pay_type => "Check")
        put :update, :id => order1.id, :order => orderAttributes
        order1.reload
      end
      
      it "updates the order record" do
        expect(order1.name).to eq("Fred")
        expect(order1.address).to eq("Another Address")
        expect(order1.email).to eq("bla@bla.com")
        expect(order1.pay_type).to eq("Check")
      end
    end
  
    describe "DELETE #destroy" do
      before(:each) do 
        @idRemoved = order1.id
        delete :destroy, :id => order1.id
      end
      
      it "destroys an order" do 
        expect(Order.exists?(@idRemoved)).to be false
      end
    end
  end
  
  context "if not logged in" do
    describe "GET #index" do
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to user_session_path
      end
    end
  end
  
  describe "GET #new" do
    before(:each) do
      get :new
    end
    
    context "cart has line items" do
      let!(:item1){FactoryGirl.create(:line_item)}
    
      it "cart is not empty" do
        expect(Cart.find(item1.cart_id)).not_to be nil
      end
    
      it "prepares new order" do      
       expect(Order.all.count).to eq(0)
      end
    end
    
    context "cart has no line items" do
      it "redirects to store index" do
        expect(assigns(:cart).line_items.empty?).to be true
        expect(response).to redirect_to store_url
      end
    end
  end
  
  describe "POST #create" do
    let!(:item1){FactoryGirl.create(:line_item)}
    before(:each) do
      orderAttributes = FactoryGirl.attributes_for(:order, :name => "JOHN", :address => "RANDOM ADD", :email => "a@y.com",
                                                   :pay_type => "Check")
      post :create, :order => orderAttributes
    end
    
    it "creates a new order" do
      expect(Order.all.count).to eq(1)
    end
     
  end
end
