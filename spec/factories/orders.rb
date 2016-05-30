FactoryGirl.define do
  factory :order do
    name 'Joe'
    address 'Random'
    email 'randomemail@email.com'
    pay_type 'Check'
  end
end