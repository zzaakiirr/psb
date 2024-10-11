# frozen_string_literal: true

require "rails_helper"

RSpec.describe Author do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_length_of(:surname).is_at_most(255) }
    it { is_expected.to validate_length_of(:patronymic).is_at_most(255) }
  end
end
