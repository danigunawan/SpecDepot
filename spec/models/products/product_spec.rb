require "spec_helper"
require "rails_helper"

describe Product do
  
  let!(:product1){ FactoryGirl.create(:product, :title => "Random Testing") }
  let!(:product2){ FactoryGirl.create(:product, :title => "Tandom Testing") }
  let!(:product3){ FactoryGirl.create(:product, :title => "Sandom Testing") }
  
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :image_url }
  
  it { is_expected.to validate_uniqueness_of :title }
  it { is_expected.to validate_length_of :title }
  
  it { is_expected.to validate_numericality_of :price }
  
  it "should not allow value less than 0.01" do
    product = Product.new
    expect(product).not_to allow_value(0.001).for(:price)
  end
  
  it "should allow value matching pattern" do
    product = Product.new
    expect(product).to allow_value("jack.jpg").for(:image_url)
    expect(product).to allow_value("jack.gif").for(:image_url)
    expect(product).to allow_value("jack.PNG").for(:image_url)
  end
  
  it "should not allow value not matching pattern" do
    product = Product.new
    expect(product).not_to allow_value("jack.orl").for(:image_url)
    expect(product).not_to allow_value("jack.SK").for(:image_url)
    expect(product).not_to allow_value("jack.asd").for(:image_url)
  end
  
  it "should have no referencing line item" do 
     product = Product.create
     expect(product.send(:ensure_not_referenced_by_any_line_item)).to be true
  end
  
  it "should return most updated product" do
    expect(Product.latest).to eq(Product.order('updated_at').last)
  end
end
