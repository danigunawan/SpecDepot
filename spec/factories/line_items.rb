FactoryGirl.define do
  factory :line_item do
    association :product
    cart

    order_id nil
    quantity 0
  end
end

#
# FactoryGirl.define do
#   factory :line_item do
#
#     quantity 0
#   end
# end