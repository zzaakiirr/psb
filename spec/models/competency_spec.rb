# frozen_string_literal: true

require "rails_helper"

RSpec.describe Competency do
  subject(:competency) { build(:competency) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:course).optional }
  end
end
