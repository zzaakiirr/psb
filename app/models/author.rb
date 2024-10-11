# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :courses, dependent: :nullify

  validates :name, presence: true
  validates :name, :surname, :patronymic, length: { maximum: 255 }
end
