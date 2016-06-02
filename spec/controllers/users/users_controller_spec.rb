require 'spec_helper'
require 'rails_helper'


describe UsersController do

  let(:user1) {FactoryGirl.create(:user)}
  let(:user2) {FactoryGirl.create(:user)}
  let(:user3) {FactoryGirl.create(:user)}

  before(:each) do
    sign_in user1
  end

  describe "GET #show" do
    
    before(:each) do
      get :show, :id => user1.id
    end
    
    it "responds with status 200" do
      expect(response.status).to eq(200)
    end
    
    it "returns the show template" do
      expect(response).to render_template("show")
    end
    
    it "returns the chosen user from list of users" do
      expect(User.exists?(user1.id)).to eq(true)
      expect(assigns(:user)).to eq(user1)
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
    
    it "loads a list of users ordered by name" do      
      array = [user1,user2,user3].sort_by{|user| [user.name.downcase, user.id]}
      users = assigns(:users)
      (0..2).each do |n|
        expect(users[n].name).to eq(array[n].name)
      end
    end
    
  end
end
    