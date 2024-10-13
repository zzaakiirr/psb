# frozen_string_literal: true

require "rails_helper"

RSpec.describe Courses::DestroyService, "#execute" do
  subject(:result) { described_class.new(course).execute }

  let!(:course) { create(:course) }

  it "destroys course and returns success" do
    expect do
      expect(result).to be_success
    end.to change { Course.count }.by(-1)

    expect(Course.exists?(course.id)).to eq(false)
  end

  context "when course destruction fails" do
    before do
      allow(course).to receive(:destroy).and_return(false)
      course.errors.add(:base, "err msg")
    end

    it "does not destroy course and returns error" do
      expect do
        expect(result).to be_error
        expect(result.message).to eq "err msg"
      end.not_to change { Course.count }

      expect(Course.exists?(course.id)).to eq(true)
    end
  end
end
