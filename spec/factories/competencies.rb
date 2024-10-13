# frozen_string_literal: true

FactoryBot.define do
  factory :competency do
    sequence(:title) { |n| "competency-#{n}" }
    course { association(:course) }
  end
end
