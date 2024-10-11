# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "jonh-#{n}" }
    sequence(:surname) { |n| "doe-#{n}" }
    sequence(:patronymic) { |n| "surname-#{n}" }
  end
end
