# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :author
  has_many :competencies, dependent: :nullify

  validates :title, presence: true, uniqueness: { scope: :author_id }, length: { maximum: 255 }
  validates :author, presence: true
end
