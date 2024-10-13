# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authors::DestroyService, "#execute" do
  subject(:result) { described_class.new(author).execute(new_courses_author: new_courses_author) }

  let!(:author) { create(:author) }

  shared_examples "error" do |err_msg|
    it "does not destroy author and return error" do
      expect do
        expect(result).to be_error
        expect(result.message).to eq err_msg
      end.to(not_change { Author.count })

      expect(Authors::ReassignCoursesService).to have_received(:new).with(
        old_author: author,
        new_author: new_courses_author
      )
      expect(reassignment_service_stub).to have_received(:execute)

      expect(Author.exists?(author.id)).to eq(true)
    end
  end

  before do
    allow(Authors::ReassignCoursesService).to receive(:new).and_return(reassignment_service_stub)
  end

  let(:new_courses_author) { nil }
  let(:reassignment_service_stub) { instance_double(Authors::ReassignCoursesService, execute: reassigment_result) }

  context "when reassignment succeeds" do
    let(:reassigment_result) { ServiceResponse.success }

    it "destroys author and returns success" do
      expect do
        expect(result).to be_success
      end.to change { Author.count }.by(-1)

      expect(Authors::ReassignCoursesService).to have_received(:new).with(
        old_author: author,
        new_author: new_courses_author
      )
      expect(reassignment_service_stub).to have_received(:execute)

      expect(Author.exists?(author.id)).to eq(false)
    end

    context "when author destruction fails" do
      before do
        allow(author).to receive(:destroy).and_return(false)
        author.errors.add(:base, "err msg")
      end

      it_behaves_like "error", "err msg"
    end
  end

  context "when reassignment fails" do
    let(:reassigment_result) { ServiceResponse.error(message: "reassignment failed") }

    it_behaves_like "error", "reassignment failed"
  end
end
