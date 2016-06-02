require 'spec_helper'
require 'rails_helper'

describe StoreController do
  describe "get #index" do
    let!(:category3) {FactoryGirl.create(:category, :name => 'Education')}
    let!(:product1) {FactoryGirl.create(:product)}
    let!(:product2) {FactoryGirl.create(:product, :title => 'Ruby Programming 1.9',
      :description => "Ruby is the fastest growing and most exciting dynamic language out there. 
      If you need to get working programs delivered fast, you should add Ruby to your toolbox.",
      :price => '14.95',
      :image_url => 'rb.jpg',
      :category_id => category3.id)}
      
    context "has search query input" do
      context "search category input is title" do
        before(:each) do 
          get :index, :search_query => 'script', :search_category => 'title'
        end
      
        it "checks if search category is title" do
          expect(assigns(:search_category)).to eq('title')
        end
      
        it "returns all products by title" do
          productList = Product.joins("LEFT JOIN categories on products.category_id = categories.id").where("title LIKE '%script%'")
          controllerList = assigns(:products)
   
          productList.zip(controllerList).each do |pList, cList|
            Product.columns.each do |column|
              expect(cList.send(column.name)).to eq(pList.send(column.name))
            end
          end
        end
      end
      
      context "search query input is category" do
        before(:each) do 
          get :index, :search_query => 'Education', :search_category => 'category'
        end
        
        it "checks if search category is category" do
          expect(assigns(:search_category)).to eq('category')
        end
        
        it "returns all products by category" do
          productList = Product.joins("LEFT JOIN categories on products.category_id = categories.id").where("name LIKE '%Education%'")
          controllerList = assigns(:products)
        
          productList.zip(controllerList).each do |pList, cList|
            Product.columns.each do |column|
              expect(cList.send(column.name)).to eq(pList.send(column.name))
            end
          end
        end
      end
      
    end
    
    context "has no search query input" do  
      it "returns all products" do
        get :index
        productList = Product.joins("LEFT JOIN categories on products.category_id = categories.id").order("LOWER(name)","LOWER(title)", "price")
        controllerList = assigns(:products)
        
        productList.zip(controllerList).each do |pList, cList|
          Product.columns.each do |column|
            expect(cList.send(column.name)).to eq(pList.send(column.name))
          end
        end
        
      end
    end
  end
end