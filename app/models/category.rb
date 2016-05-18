class Category < ActiveRecord::Base
  has_many :products
  validates :name, uniqueness: true, presence: true
  
  def self.names
    all.collect { |category_type| category_type.name }
  end
  
end