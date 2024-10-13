# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :courses, dependent: :nullify

  validates :name, presence: true
  validates :name, :surname, :patronymic, length: { maximum: 255 }

  scope :by_search, lambda { |query|
    %i[name surname patronymic].reduce(none) do |result, field|
      result.or(where_field_matches_query(field, query))
    end
  }
end
