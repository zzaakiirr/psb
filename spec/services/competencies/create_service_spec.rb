# frozen_string_literal: true

require "rails_helper"

RSpec.describe Competencies::CreateService, "#execute" do
  subject(:result) { described_class.new(params).execute }

  let(:course) { create(:course) }

  shared_examples "returns error" do |err_msg|
    it "does not create competency" do
      expect do
        expect(result).to be_error
        expect(result.message).to include(err_msg)
      end.not_to change { Competency.count }
    end
  end

  context "without any params" do
    let(:params) { {} }

    it_behaves_like "returns error", "Title can't be blank"
  end

  context "with too long title" do
    let(:params) { { title: "title" * 500 } }

    it_behaves_like "returns error", "Title is too long"
  end

  context "with non-permitted params" do
    let(:params) { { title: "title", course_id: course.id, non_permitted_param: "non-permitted" } }

    it "creates competency with permitted params and returns success" do
      expect do
        expect(result).to be_success
      end.to change { Competency.count }.by(1)

      created_competency = Competency.last
      expect(created_competency.title).to eq(params.fetch(:title))
      expect(created_competency.course_id).to eq(params.fetch(:course_id))
    end
  end

  context "with all params" do
    let(:params) { { title: "Test competency", course_id: course.id } }

    it "creates user and returns success" do
      expect do
        expect(result).to be_success
      end.to change { Competency.count }.by(1)

      created_competency = Competency.last
      expect(created_competency.title).to eq params.fetch(:title)
      expect(created_competency.course_id).to eq(params.fetch(:course_id))
    end
  end
end
