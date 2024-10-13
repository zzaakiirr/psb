# frozen_string_literal: true

require "rails_helper"

RSpec.describe Courses::CreateService, "#execute" do
  subject(:result) { described_class.new(params).execute }

  let(:author) { create(:author) }

  shared_examples "returns error" do |err_msg|
    it "does not create course" do
      expect do
        expect(result).to be_error
        expect(result.message).to include(err_msg)
      end.not_to change { Course.count }
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
    let(:params) { { title: "title", author_id: author.id, non_permitted_param: "non-permitted" } }

    it "creates course with permitted params and returns success" do
      expect do
        expect(result).to be_success
      end.to change { Course.count }.by(1)

      created_course = Course.last
      expect(created_course.title).to eq(params.fetch(:title))
      expect(created_course.author_id).to eq(params.fetch(:author_id))
    end
  end

  context "with all params" do
    let(:params) { { title: "Test course", author_id: author.id } }

    it "creates user and returns success" do
      expect do
        expect(result).to be_success
      end.to change { Course.count }.by(1)

      created_course = Course.last
      expect(created_course.title).to eq params.fetch(:title)
      expect(created_course.author_id).to eq(params.fetch(:author_id))
    end
  end
end
