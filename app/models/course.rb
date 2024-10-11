# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :author

  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :author, presence: true
end
