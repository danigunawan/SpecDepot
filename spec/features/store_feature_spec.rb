require 'spec_helper'
require 'rails_helper'
require 'capybara/rspec'

feature "Store Interface" do

  let!(:category1) { FactoryGirl.create(:category, :name => "Educational") }
  let!(:category2) { FactoryGirl.create(:category, :name => "Fiction") }


  let!(:product1){ FactoryGirl.create(:product, :title => 'CoffeeScript', 
    :description => "CoffeeScript is JavaScript done right. It provides all of JavaScript's functionality wrapped in a cleaner, more succinct syntax. In the first book on this exciting new language, CoffeeScript guru Trevor Burnham shows you how to hold onto all the power and flexibility of JavaScript while writing clearer, cleaner, and safer code.",
    :price => 10.00,
    :image_url => "cs.jpg",
    :category_id => category1.id) }
  
  let!(:product2){ FactoryGirl.create(:product, :title => 'Rails Test Prescription', 
      :description => "Rails Test Prescriptions is a comprehensive guide to testing Rails applications, covering Test-Driven Development from both a theoretical perspective (why to test) and from a practical perspective (how to test effectively). It covers the core Rails testing tools and procedures for Rails 2 and Rails 3, and introduces popular add-ons, including Cucumber, Shoulda, Machinist, Mocha, and Rcov.",
      :price => 11.00,
      :image_url => "rtp.jpg",
      :category_id => category1.id) }  
      
  let!(:product4){ FactoryGirl.create(:product, :title => 'RandomLongTitleHere', 
      :description => "Rails Test Prescriptions is a comprehensive guide to testing Rails applications, covering Test-Driven Development from both a theoretical perspective (why to test) and from a practical perspective (how to test effectively). It covers the core Rails testing tools and procedures for Rails 2 and Rails 3, and introduces popular add-ons, including Cucumber, Shoulda, Machinist, Mocha, and Rcov.",
      :price => 11.00,
      :image_url => "rtp.jpg",
      :category_id => category1.id) }      
      
  let!(:product3){ FactoryGirl.create(:product, :title => 'Programming Ruby 1.9 & 2.0', 
      :description => "Ruby is the fastest growing and most exciting dynamic language out there. If you need to get working programs delivered fast, you should add Ruby to your toolbox.",
      :price => 10.00,
      :image_url => "ruby.jpg",
      :category_id => category2.id) }    
      
  let!(:product5){ FactoryGirl.create(:product, :title => 'sadadadqewq', 
      :description => "Ruby is the fastest growing and most exciting dynamic language out there. If you need to get working programs delivered fast, you should add Ruby to your toolbox.",
      :price => 10.00,
      :image_url => "ruby.jpg",
      :category_id => category2.id) }       
    
    before(:each) do
      visit "/"
    end
    
    context "displays 2 pages of products" do
      scenario "displays these products on 1st page" do
        expect(page).to have_content("CoffeeScript")
        expect(page).to have_content("Rails Test Prescription")
        expect(page).to have_content("Programming Ruby 1.9 & 2.0")
        expect(page).to have_content("RandomLongTitleHere")
        expect(page).not_to have_content("sadadadqewq")
      end
      
      scenario "displays this product on 2nd page" do
        first('.next_page').click
        expect(page).not_to have_content("CoffeeScript")
        expect(page).not_to have_content("Rails Test Prescription")
        expect(page).not_to have_content("Programming Ruby 1.9 & 2.0")
        expect(page).not_to have_content("RandomLongTitleHere")
        expect(page).to have_content("sadadadqewq")
      end
      
      scenario "displays this product on 2nd page" do
        first('.previous_page').click
        expect(page).to have_content("CoffeeScript")
        expect(page).to have_content("Rails Test Prescription")
        expect(page).to have_content("Programming Ruby 1.9 & 2.0")
        expect(page).to have_content("RandomLongTitleHere")
        expect(page).not_to have_content("sadadadqewq")
      end
    end
    
    scenario "user searches for item via title" do
      fill_in "search_query", with: "Script"
      click_button "Submit"
      expect(page).to have_content("CoffeeScript")
      expect(page).to have_content("Rails Test Prescription")
      expect(page).not_to have_content("Programming Ruby 1.9 & 2.0")
    end

    scenario "user searches for item via category" do      
      fill_in "search_query", with: category1.name
      select "category", :from => "search_category"

      click_button "Submit"
      expect(page).to have_content("CoffeeScript")
      expect(page).to have_content("Rails Test Prescription")
      expect(page).not_to have_content("Programming Ruby 1.9 & 2.0")
    end
    
    scenario "clicks search without query" do
      click_button "Submit"
      expect(page).to have_content("CoffeeScript")
      expect(page).to have_content("Rails Test Prescription")
      expect(page).to have_content("Programming Ruby 1.9 & 2.0")
    end
  
    context "shows selected product" do
      before(:each) do
        find(:xpath, "//div[p[contains(.,'CoffeeScript')]]/h3/a").click
      end
      
      scenario "displays selected product information" do
        expect(page).to have_content("Title: CoffeeScript")
      end
      
      scenario "add selected product to cart" do
        click_link "Add"
        expect(page.has_css?("#cart")).to be true
      end
    end

    scenario "add product to cart" do
      find(:xpath, "//div[p[contains(.,'CoffeeScript')]]/div/form/input").click
      expect(page.has_css?("#cart")).to be true
    end
    
    context "with product in cart", js: true do
      before(:each) do
        find(:xpath, "//div[p[contains(.,'CoffeeScript')]]/div/form/input").click
        sleep 1
      end
      
      scenario "decrement current item" do
        find(:xpath, "//div[p[contains(.,'CoffeeScript')]]/div/form/input").click
        find(:xpath, "//tr[contains(@id, 'current_item')]/td/form/input[contains(@class, 'btn-xs btn-circle')]").click
        sleep 1
        expect(LineItem.order("created_at").last.quantity).to eq(1)
      end
      
      scenario "empty cart via decrement button" do
        currentItem = LineItem.order("created_at").last
        find(:xpath, "//tr[contains(@id, 'current_item')]/td/form/input[contains(@class, 'btn-xs btn-circle')]").click
        sleep 1
        expect(LineItem.exists?(currentItem.id)).to be false
      end
      
      scenario "empty cart via empty cart button" do
        currentItem = LineItem.order("created_at").last      
        click_button "Empty Cart"
        page.accept_confirm
        sleep 1
        expect(LineItem.exists?(currentItem.id)).to be false
      end
    end

end