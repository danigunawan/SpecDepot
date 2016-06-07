require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "Category Interface" do
  
  let!(:user1){ FactoryGirl.create(:user) }
  
  let!(:category1) { FactoryGirl.create(:category, :name => "Fiction") }
  let!(:category2) { FactoryGirl.create(:category, :name => "Non-fiction") }
  let!(:category3) { FactoryGirl.create(:category, :name => "Educational") }

  before(:each) do
    visit store_path
    click_link "Login"
    
    fill_in "user_email", with: user1.email
    fill_in "user_password", with: user1.password 
    click_button "Log in"
    click_link "Categories"
  end

  scenario "list all categories" do
    expect(page).to have_content("#{category1.name}")
    expect(page).to have_content("#{category2.name}")
    expect(page).to have_content("#{category3.name}")
  end

  scenario "create new category" do
    click_link "New Category"
    fill_in "category_name", with: "Random"
    click_button "Create Category"
    expect(page).to have_content("Category: Random")
  end
  
  context "show category" do    
    before(:each) do
      find(:xpath, "//tr[td[contains(.,'Fiction')]]/td/a", :text => "Show").click
    end
    
    scenario "displays category information" do
      expect(page).to have_content("Category: Fiction")
    end
    
    scenario "edit selected category information" do
      click_link "Edit"
      fill_in "category_name", with: "Random"
      click_button "Update Category"
      expect(page).to have_content("Category: Random")
    end
  end
  
  scenario "edit category" do
    find(:xpath, "//tr[td[contains(.,'Fiction')]]/td/a", :text => "Edit").click
    fill_in "category_name", with: "Random"
    click_button "Update Category"
    expect(page).to have_content("Category: Random")
  end
  
  scenario "delete category", js: true do
    find(:xpath, "//tr[td[contains(.,'Fiction')]]/td/a", :text => "Destroy").click
    page.accept_confirm
    sleep 1
    expect(page).not_to have_content("Fiction")
  end
end