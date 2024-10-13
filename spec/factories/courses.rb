# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    sequence(:title) { |n| "course-#{n}" }
    author { association(:author) }
  end
end
