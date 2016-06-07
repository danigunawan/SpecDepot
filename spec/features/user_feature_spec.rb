require "rails_helper"
require "spec_helper"
require "capybara/rspec"

feature "User Interface" do
  
  let!(:user1){ FactoryGirl.create(:user, :name => "Jon") }
  let!(:user2){ FactoryGirl.create(:user, :name => "George") }
  let!(:user3){ FactoryGirl.create(:user, :name => "Joe") }
  
  before(:each) do
    visit store_path
    click_link "Login"
  end
  
  context "User not yet made" do
    scenario "User signing up for first time" do
      click_link "Sign up"
    
      fill_in "user_name", with: "Greg"
      fill_in "user_email", with: "email@email.com"
      fill_in "user_password", with: "secret"
      fill_in "user_password_confirmation", with: "secret"
    
      click_button "Sign up"
    
      expect(page).to have_content("You have signed up successfully")
    end
  end
  
  context "User already made" do
    scenario "User logs in" do
      fill_in "user_email", with: user1.email
      fill_in "user_password", with: user1.password
      click_button "Log in"
      
      expect(page).to have_content("Signed in successfully")
    end
    
    scenario "Forgot password", js: true do
      click_link "Forgot your password?"
      fill_in "user_email", with: user1.email
      click_button "Send me reset password instructions"
      expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
    end
    
  end
  
  context "visits user page" do
    before(:each) do
      fill_in "user_email", with: user1.email
      fill_in "user_password", with: user1.password
      click_button "Log in"
      click_link "Users"
    end
    
    scenario "displays a list of users" do
      expect(page).to have_content("Jon")
      expect(page).to have_content("George")
      expect(page).to have_content("Joe")
    end
    
    context "shows selected user" do
      before(:each) do
        find(:xpath, "//tr[td[contains(.,'George')]]/td/a", :text => 'Show').click
      end
      
      scenario "displays user information" do
        expect(page).to have_content("Name: #{user2.name}")
        expect(page).to have_content("Email: #{user2.email}")
      end
      
      scenario "edits user information" do
        expect(page).to have_content("Name: #{user2.name}")
        expect(page).to have_content("Email: #{user2.email}")
      end
    end
    
    scenario "edit selected user" do
      find(:xpath, "//tr[td[contains(.,'George')]]/td/a", :text => 'Edit').click
      fill_in "user_name", with: "Will"
      fill_in "user_email", with: "will@email.com"
      fill_in "user_password", with: "secret"
      fill_in "user_password_confirmation", with: "secret"
      click_button "Update User"
      
      expect(page).to have_content("Name: Will")
      expect(page).to have_content("Email:will@email.com")
    end
    
    scenario "delete selected user", js: true do
      deleteId = user2.id
      find(:xpath, "//tr[td[contains(.,'George')]]/td/a", :text => 'Destroy').click
      page.accept_confirm
      sleep 1
      
      expect(User.exists?(deleteId)).to be false
      expect(page).not_to have_content("George")
    end
  end
end