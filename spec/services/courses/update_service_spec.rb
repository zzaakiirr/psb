# frozen_string_literal: true

require "rails_helper"

RSpec.describe Courses::UpdateService, "#execute" do
  subject(:result) { described_class.new(course: course, params: params).execute }

  let(:course) { create(:course, title: "old_title", author: old_author) }
  let(:old_author) { create(:author) }

  context "without any params" do
    let(:params) { {} }

    it "does not update course and returns success" do
      expect do
        expect(result).to be_success
      end.not_to change { course.reload }
    end
  end

  context "with too long title" do
    let(:params) { { title: "title" * 500 } }

    it "does not update course" do
      expect do
        expect(result).to be_error
        expect(result.message).to include("Title is too long")
      end.not_to change { course.reload }
    end
  end

  context "with non-permitted params" do
    let(:params) { { title: "new_title", non_permitted_param: "non-permitted" } }

    it "updates course with permitted params and returns success" do
      expect do
        expect(result).to be_success
      end.to change { course.reload.title }.from("old_title").to("new_title")
    end
  end

  context "with all params" do
    let(:params) { { title: "new_title", author_id: new_author.id } }
    let(:new_author) { create(:author) }

    it "updates course and returns success", :aggregate_failures do
      expect do
        expect(result).to be_success
        course.reload
      end.to(
        change { course.title }.from("old_title").to(params[:title])
          .and(change { course.author_id }.from(old_author.id).to(params[:author_id]))
      )
    end
  end
end
