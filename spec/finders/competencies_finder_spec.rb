# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompetenciesFinder, "#execute" do
  subject(:competencies) { described_class.new(params).execute }

  let!(:competency1) { create(:competency, title: "Abc") }
  let!(:competency2) { create(:competency, title: "abc") }
  let!(:competency3) { create(:competency, title: "dEf") }

  context "without any params" do
    let(:params) { {} }

    it "returns all competencies" do
      expect(competencies).to contain_exactly(competency1, competency2, competency3)
    end
  end

  context "with pagination params" do
    let(:params) { { page: 1, per_page: 1 } }

    it "returns paginated competencies" do
      expect(competencies).to contain_exactly(competency1)
    end
  end

  context "with search query" do
    let(:params) { { search: "A" } }

    it "returns competencies matching search" do
      expect(competencies).to contain_exactly(competency1, competency2)
    end
  end

  context "with filter by course" do
    let(:params) { { course_id: competency1.course_id } }

    it "returns course's competencies" do
      expect(competencies).to contain_exactly(competency1)
    end
  end
end
