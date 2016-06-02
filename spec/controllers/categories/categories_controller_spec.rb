require 'spec_helper'
require 'rails_helper'

describe CategoriesController do
  let!(:user1) {FactoryGirl.create(:user)}
  context "if logged in" do
    let!(:category1) {FactoryGirl.create(:category)}
    
    before(:each) do
      sign_in user1
    end  
    
    describe "get #index" do
      it "displays all categories" do
        get :index
        expect(assigns(:categories)).to eq(Category.all)
      end
    end
    
    describe "get #show" do
      it "shows a category" do
        get :show, :id => category1.id
        expect(assigns(:category)).to eq(category1)
      end
    end
    
    describe "get #edit" do
      before(:each) do
        get :edit, :id => category1.id
      end
      
      it "renders edit template" do
        expect(response).to render_template("edit")
      end
      
      it "checks if category exists" do
        expect(Category.exists?(category1.id)).to be true
      end
      
      it "responds with status 200" do 
        expect(response.status).to eq(200)
      end
    end
    
    describe "put #update" do
      it "updates an existing category" do
        put :update, :id => category1.id, :category => FactoryGirl.attributes_for(:category, :name => 'Change')
        category1.reload
        expect(category1.name).to eq('Change')
      end
    end
    
    describe "post #create" do
      it "creates a new category" do
        post :create, :category => FactoryGirl.attributes_for(:category, :name => 'Another')
        @categoryMade = Category.find_by(name: "Another")
        expect(assigns(:category)).to eq(@categoryMade)
      end
    end
    
    describe "delete #destroy" do
      it "destroys a category" do
        delete :destroy, :id => category1.id
        expect(Category.exists?(category1.id)).to be false
      end
    end
  end
  
  context "if not logged in" do
    it "redirects to sign in page" do 
      get :index
      expect(response).to redirect_to(user_session_path)
    end
  end
  
end