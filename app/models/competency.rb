# frozen_string_literal: true

class Competency < ApplicationRecord
  belongs_to :course, optional: true

  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
end
