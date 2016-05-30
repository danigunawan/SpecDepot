FactoryGirl.define do
  factory :user do
    name 'Dave'
    email 'dave@email.com'
    password 'secret'
    password_confirmation 'secret'
  end
end