# frozen_string_literal: true

class Author < ApplicationRecord
  validates :name, presence: true
  validates :name, :surname, :patronymic, length: { maximum: 255 }

  def self.random_author
    order("RANDOM()").take
  end
end
