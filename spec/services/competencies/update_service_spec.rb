# frozen_string_literal: true

require "rails_helper"

RSpec.describe Competencies::UpdateService, "#execute" do
  subject(:result) { described_class.new(competency: competency, params: params).execute }

  let(:competency) { create(:competency, title: "old_title", course: old_course) }
  let(:old_course) { create(:course) }

  context "without any params" do
    let(:params) { {} }

    it "does not update competency and returns success" do
      expect do
        expect(result).to be_success
      end.not_to change { competency.reload }
    end
  end

  context "with too long title" do
    let(:params) { { title: "title" * 500 } }

    it "does not update competency" do
      expect do
        expect(result).to be_error
        expect(result.message).to include("Title is too long")
      end.not_to change { competency.reload }
    end
  end

  context "with non-permitted params" do
    let(:params) { { title: "new_title", non_permitted_param: "non-permitted" } }

    it "updates competency with permitted params and returns success" do
      expect do
        expect(result).to be_success
      end.to change { competency.reload.title }.from("old_title").to("new_title")
    end
  end

  context "with all params" do
    let(:params) { { title: "new_title", course_id: new_course.id } }
    let(:new_course) { create(:course) }

    it "updates competency and returns success", :aggregate_failures do
      expect do
        expect(result).to be_success
        competency.reload
      end.to(
        change { competency.title }.from("old_title").to(params[:title])
          .and(change { competency.course_id }.from(old_course.id).to(params[:course_id]))
      )
    end
  end
end
