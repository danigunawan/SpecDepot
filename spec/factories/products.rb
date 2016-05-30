FactoryGirl.define do
  factory :product do
    title 'CoffeeScript'
    description "CoffeeScript is JavaScript done right. It provides all of JavaScript's functionality wrapped in a cleaner, more succinct syntax. In the first book on this exciting new language, CoffeeScript guru Trevor Burnham shows you how to hold onto all the power and flexibility of JavaScript while writing clearer, cleaner, and safer code."
    image_url 'cs.jpg'
    price '36.00'
    category_id '1'
  end
end