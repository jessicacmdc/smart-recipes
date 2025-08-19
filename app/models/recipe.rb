class Recipe < ApplicationRecord
  belongs_to :user

  validates :title, :ingredients, :instruction, presence: true
  validates :title, uniqueness: true
end
