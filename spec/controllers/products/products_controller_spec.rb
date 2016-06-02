require 'spec_helper'
require 'rails_helper'

describe ProductsController do
  let!(:category2) {FactoryGirl.create(:category, :name => 'Non-fiction')}
  let!(:category3) {FactoryGirl.create(:category, :name => 'Education')}
  let!(:product1) {FactoryGirl.create(:product)}
  let!(:product2) {FactoryGirl.create(:product, 
    :description => "Ruby is the fastest growing and most exciting dynamic language out there. 
    If you need to get working programs delivered fast, you should add Ruby to your toolbox.",
    :price => '14.95',
    :image_url => 'rb.jpg',
    :category_id => category3.id)}
  let!(:product3) {FactoryGirl.create(:product, 
    :description => "Rails Test Prescriptions is a comprehensive guide to testing Rails applications, 
    covering Test-Driven Development from both a theoretical perspective (why to test) and from a practical 
    perspective (how to test effectively). It covers the core Rails testing tools and procedures for Rails 2
    and Rails 3, and introduces popular add-ons, including Cucumber, Shoulda, Machinist, Mocha, and Rcov.",
    :price => '34.95',
    :image_url => 'rtp.jpg',
    :category_id => category2.id) }

  let!(:user1) {FactoryGirl.create(:user)}

  before(:each) do
    sign_in user1
  end  

  context "Assuming valid values" do
      describe "GET #show" do
        before(:each) do
          get :show, :id => product1.id
        end
        
        it "responds with status 200" do 
          expect(response.status).to eq(200)
        end
    
        it "returns the show template" do
          expect(response).to render_template("show")
        end
    
        it "returns the product found" do
          expect(assigns(:product)).to eq(Product.find(1))
        end
      end
      
      describe "GET #edit" do
        before(:each) do
          get :edit, :id => product1.id
        end
        
        it "checks if product exists" do
          expect(Product.exists?(product1.id)).to be true
        end
        
        it "responds with status 200" do 
          expect(response.status).to eq(200)
        end
        
        it "returns the edit template" do
          expect(response).to render_template("edit")
        end
      end
      
      describe "POST #create" do
        before(:each) do
          post :create, :product =>  FactoryGirl.attributes_for(:product, :title => "New Title Random Test",
          :description => "New Description", :image_url => "newImage.jpg", :price => 10, :category_id => 1)
        end
    
        it "responds with status 302" do
          expect(response.status).to eq(302)
        end
    
        it "redirects to show product" do
          @productMade = Product.find_by(title: "New Title Random Test")
          expect(response).to redirect_to (product_path(:id => @productMade.id))
        end
    
        it "creates a new product" do
          @productMade = Product.find_by(title: "New Title Random Test")
          expect(assigns(:product)).to eq(@productMade)
        end
      end
  
      describe "GET #index" do
        before(:each) do
          get :index
        end
        
        it "responds with status 200" do
          expect(response.status).to eq(200)
        end
    
        it "returns the index template" do
          expect(response).to render_template("index")
        end
    
        it "loads a list of products ordered by category and name" do
        #  array = Product.sort_by{|product| [product.category.name, product.title.downcase]}   
          array = Product.joins("LEFT JOIN categories on category_id = categories.id").order("LOWER(name)", "LOWER(title)", "price")
          expect(assigns(:products)).to match_array(array)               
        end
      end
  
      describe "GET #new" do
        before(:each) do
          get :new
        end
    
        it "responds with status 200" do
          expect(response.status).to eq(200)
        end
    
        it "returns the new template" do
          expect(response).to render_template("new")
        end
    
        it "creates a new product" do
          expect(assigns(:product))
        end
      end
  
      describe "PUT #update" do
        before(:each) do
          @productAttributes = FactoryGirl.attributes_for(:product, :title => "New Title TEST",
          :description => "New Description", :image_url => "newImage.jpg", :price => 10, :category_id => 1)

          put :update, :id => product1.id, :product => @productAttributes
          product1.reload
        end

        it "responds with status 200" do
          expect(response.status).to eq(302)
        end

        it "redirects to show product" do
          expect(response).to redirect_to (product_path(:id => product1.id))
        end

        it "updates a product" do
          expect(product1.title).to eq("New Title TEST")
          expect(assigns(:product)).to eq(product1)
        end
      end
  
  
      describe "DELETE #destroy" do
        before(:each) do
          delete :destroy, :id => product1.id
        end

        it "responds with status 302" do
          expect(response.status).to eq(302)
        end

        it "redirects to index" do
          expect(response).to redirect_to products_url
        end

        it "destroys a product" do
          expect(Product.exists?(product1.id)).to be false
        end
        
        it "flashes product was destroyed" do
          expect(flash[:notice]).to eq('Product was successfully destroyed.')
        end
      end
  end
    
  context "Assuming invalid values" do
      describe "GET #show" do
        
        before(:each) do
          product1.id = 200
          get :show, :id => product1.id
        end
        
        it "responds with status 302" do
          expect(response.status).to eq(302)
        end
    
        it "returns the index template" do
          expect(response).to redirect_to products_url
        end
    
        it "flashes no such product exists error" do
          expect(flash[:notice]).to eq('No such product exists')
        end
      end

      describe "PUT #update" do
        before(:each) do
          @productAttributes = FactoryGirl.attributes_for(:product, :title => "Short",
          :description => "New Description", :image_url => "newImage.joe", :price => -10, :category_id => "RANDOM")

          @oldTitle = product1.title

          put :update, :id => product1.id, :product => @productAttributes
          product1.reload
        end

        it "responds with status 200" do
          expect(response.status).to eq(200)
        end

        it "returns the edit template" do
          expect(response).to render_template("edit")
        end

        it "does not update the product" do
          expect(product1.title).to eq(@oldTitle)
        end
        
        it "flashes product was not valid error" do
          expect(flash[:notice]).to eq('Product was not valid')
        end
      end
      
      describe "POST #create" do
        before(:each) do
          post :create, :product =>  FactoryGirl.attributes_for(:product, :title => "New",
          :description => "New Description", :image_url => "newImage.hie", :price => 10, :category_id => "RANDOM")
        end
    
        it "responds with status 200" do
          expect(response.status).to eq(200)
        end
    
        it "returns the new template" do
          expect(response).to render_template("new")
        end
    
        it "flashes product was not created error" do
          expect(flash[:notice]).to eq('Product was not created.')
        end
      end
      
      describe "DELETE #destroy" do
         before(:each) do
           delete :destroy, :id => 200
         end
        
         it "responds with status 302" do
           expect(response.status).to eq(302)
         end
        
         it "redirects to index" do
           expect(response).to redirect_to products_url
         end
        
         it "flashes no such product exists error" do
           expect(flash[:notice]).to eq('No such product exists')
         end
      end
    end
end