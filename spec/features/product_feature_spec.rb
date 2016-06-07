require 'spec_helper'
require 'rails_helper'
require 'capybara/rspec'

feature "Product Interface" do
  
  let!(:user1) { FactoryGirl.create(:user) }
  
  let!(:category1) { FactoryGirl.create(:category) }
  let!(:category2) { FactoryGirl.create(:category) }
  let!(:category3) { FactoryGirl.create(:category) }
  
  let!(:product1){ FactoryGirl.create(:product, :title => 'CoffeeScript', 
    :description => "CoffeeScript is JavaScript done right. It provides all of JavaScript's functionality wrapped in a cleaner, more succinct syntax. In the first book on this exciting new language, CoffeeScript guru Trevor Burnham shows you how to hold onto all the power and flexibility of JavaScript while writing clearer, cleaner, and safer code.",
    :price => 10.00,
    :image_url => "cs.jpg",
    :category_id => category1.id) }
  
  let!(:product2){ FactoryGirl.create(:product, :title => 'Rails Test Prescription', 
      :description => "Rails Test Prescriptions is a comprehensive guide to testing Rails applications, covering Test-Driven Development from both a theoretical perspective (why to test) and from a practical perspective (how to test effectively). It covers the core Rails testing tools and procedures for Rails 2 and Rails 3, and introduces popular add-ons, including Cucumber, Shoulda, Machinist, Mocha, and Rcov.",
      :price => 11.00,
      :image_url => "rtp.jpg",
      :category_id => category2.id) }  
      
  let!(:product3){ FactoryGirl.create(:product, :title => 'Programming Ruby 1.9 & 2.0', 
      :description => "Ruby is the fastest growing and most exciting dynamic language out there. If you need to get working programs delivered fast, you should add Ruby to your toolbox.",
      :price => 10.00,
      :image_url => "ruby.jpg",
      :category_id => category2.id) }  
    
  let!(:product4){ FactoryGirl.create(:product, :title => 'Product Deletion Test', 
      :description => "Filled with garbage",
      :price => 10.00,
      :image_url => "ruby.jpg",
      :category_id => category3.id) }      
      
  context "visits products page" do
    before(:each) do
      visit store_path
      click_link "Login"
      
      fill_in "user_email", with: user1.email
      fill_in "user_password", with: user1.password 
      click_button "Log in"
      click_link "Products"
    end
  
    scenario "displays a list of products" do
      expect(page).to have_content("CoffeeScript")
      expect(page).to have_content("Rails Test Prescription")
      expect(page).to have_content("Programming Ruby 1.9 & 2.0")
    end

    context "shows product info" do
      before(:each) do
        find(:xpath, "//tr[td[contains(.,'Rails Test Prescriptions')]]/td[contains(@class, 'list_actions')]/a", :text => 'Show').click
      end
     
      scenario "it shows product info for clicked item" do
        expect(page).to have_content("Rails Test Prescriptions")
      end
      
      scenario "it adds product item to cart", js: true do
        click_link "Add"
        expect(page.has_css?("#cart #current_item")).to be true
        expect(LineItem.all.count).to eq(1)
      end
    end

    scenario "creates a new product" do
      click_link "New Product"
      fill_in "product_title", with: "RANDOM TITLE ADDED"
      fill_in "product_description", with: "BLALSLASLA"
      select category1.name, from: 'product_category_id'
      fill_in "product_image_url", with: "cs.jpg"
      fill_in "product_price", with: 12
      click_button "Create Product"
            
      product = Product.find_by(title: "RANDOM TITLE ADDED")
      expect(Product.exists?(product.id)).to be true
      expect(page).to have_content("RANDOM TITLE ADDED")
    end
    
    scenario "edit product info" do
      find(:xpath, "//tr[td[contains(.,'Rails Test Prescriptions')]]/td[contains(@class, 'list_actions')]/a", :text => 'Edit').click
      fill_in "product_title", with: "NEW PRODUCT TITLE"
      click_button "Update Product"
      expect(page).to have_content("NEW PRODUCT TITLE")
    end
    
    #it takes time to delete hence sleep 1...will look for a better way
    scenario "delete product", js: true do
      deleteId = product4.id
      find(:xpath, "//tr[td[contains(.,'Product Deletion Test')]]/td[contains(@class, 'list_actions')]/a", :text => 'Destroy').click 
      page.accept_confirm
      sleep 1

      expect(Product.exists?(deleteId)).to be false
      expect(page).not_to have_content("Product Deletion Test")
    end
  end
  
end