class Category < ApplicationRecord
  validates :name, :api_category_id, presence: true
  validates :api_category_id, uniqueness: true
end
