FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "Fiction#{n}"
    end
  end
end