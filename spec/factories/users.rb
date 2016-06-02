FactoryGirl.define do
  factory :user do
    
    sequence :name do |n|
      "Dave#{n}"
    end
  
    sequence :email do |n|
      "dave#{n}@email.com"
    end
  
    password 'secret'
    password_confirmation 'secret'
  end
end