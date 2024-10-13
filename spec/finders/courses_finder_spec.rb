# frozen_string_literal: true

require "rails_helper"

RSpec.describe CoursesFinder, "#execute" do
  subject(:courses) { described_class.new(params).execute }

  let!(:course1) { create(:course, title: "Abc") }
  let!(:course2) { create(:course, title: "abc") }
  let!(:course3) { create(:course, title: "dEf") }

  context "without any params" do
    let(:params) { {} }

    it "returns all courses" do
      expect(courses).to contain_exactly(course1, course2, course3)
    end
  end

  context "with pagination params" do
    let(:params) { { page: 1, per_page: 1 } }

    it "returns paginated courses" do
      expect(courses).to contain_exactly(course1)
    end
  end

  context "with search query" do
    let(:params) { { search: "A" } }

    it "returns courses matching search" do
      expect(courses).to contain_exactly(course1, course2)
    end
  end

  context "with filter by author" do
    let(:params) { { author_id: course1.author_id } }

    it "returns author's courses" do
      expect(courses).to contain_exactly(course1)
    end
  end
end
