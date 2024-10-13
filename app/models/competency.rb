# frozen_string_literal: true

class Competency < ApplicationRecord
  belongs_to :course, optional: true

  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }

  scope :by_search, ->(query) { where_field_matches_query(:title, query) }
  scope :by_course, ->(course) { where(course: course) }
end
