require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Order Interface" do
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
  
  before(:each) do
    visit store_path
  end

  context "Cart Has line items" do    
    let!(:order1) { FactoryGirl.create(:order) }
    let!(:order2) { FactoryGirl.create(:order, :name => "Fred") }
    let!(:order3) { FactoryGirl.create(:order, :name => "Jack") }
        
    context "New Order via Checkout" do
      before(:each) do
        find(:xpath, "//div[p[contains(.,'CoffeeScript')]]/div/form").click
        sleep 1
        click_button "Checkout"
      end
      
      scenario "create new order", js: true do
        fill_in "order_name", with: "Bam"
        fill_in "order_address", with: "Random address"
        fill_in "order_email", with: "a@y.com"    
        select "Check", from: 'order_pay_type'
        click_button "Place Order"
        
        orderMade = Order.find_by(name: "Bam")
        expect(Order.exists?(orderMade.id)).to be true
        expect(page).to have_content("Thank you for your order")
      end
    end
  
    context "Logged in" do
      before(:each) do
        click_link "Login"
      
        fill_in "user_email", with: user1.email
        fill_in "user_password", with: user1.password 
        click_button "Log in"
        
        find(:xpath, "//div[p[contains(.,'CoffeeScript')]]/div/form").click
        sleep 1
        click_link "Orders"    
      end
    
      scenario "displays list of orders" do
        expect(page).to have_content(order1.name)
        expect(page).to have_content(order2.name)
        expect(page).to have_content(order3.name)
      end
      
      scenario "create new order", js: true do
        click_link "New Order" 
        fill_in "order_name", with: "Bam"
        fill_in "order_address", with: "Random address"
        fill_in "order_email", with: "a@y.com"    
        select "Check", from: 'order_pay_type'
        click_button "Place Order"
        
        orderMade = Order.find_by(name: "Bam")
        expect(Order.exists?(orderMade.id)).to be true
        expect(page).to have_content("Thank you for your order")
      end
      
      scenario "edit order information" do
          find(:xpath, "//tr[td[contains(.,'Fred')]]/td/a", :text => "Edit").click
          fill_in "order_name", with: "Bam"
          click_button "Place Order"
          expect(page).to have_content("Bam")
          expect(page).to have_content(order2.address)
          expect(page).to have_content(order2.email)
          expect(page).to have_content(order2.pay_type)
      end
      
      context "show selected order" do
        before(:each) do
          find(:xpath, "//tr[td[contains(.,'Fred')]]/td/a", :text => "Show").click
        end
        
        scenario "displays selected order information" do
          expect(page).to have_content(order2.name)
          expect(page).to have_content(order2.address)
          expect(page).to have_content(order2.email)
          expect(page).to have_content(order2.pay_type)
        end
        
        scenario "edit selected order information" do
          click_link "Edit"
          fill_in "order_name", with: "Bam"
          click_button "Place Order"
          expect(page).to have_content("Bam")
          expect(page).to have_content(order2.address)
          expect(page).to have_content(order2.email)
          expect(page).to have_content(order2.pay_type)
        end
      end
      
      scenario "delete order information", js: true do
          idDelete = order2.id
          find(:xpath, "//tr[td[contains(.,'Fred')]]/td/a", :text => "Destroy").click
          page.accept_confirm
          sleep 1
          expect(Order.exists?(idDelete)).to be false
          expect(page).not_to have_content("Fred")
      end
    end
  end
  
  context "Cart has no line items" do
    before(:each) do
      click_link "Login"
    
      fill_in "user_email", with: user1.email
      fill_in "user_password", with: user1.password 
      click_button "Log in"
      click_link "Orders"    
    end
    
    scenario "create new order" do
      click_link "New Order" 
      expect(page).to have_content("Your cart is empty")
    end
  end
end