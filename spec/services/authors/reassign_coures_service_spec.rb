# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authors::ReassignCoursesService, "#execute" do
  subject(:result) { described_class.new(old_author: old_author, new_author: new_author).execute }

  let!(:old_author) { create(:author) }
  let!(:math_course) { create(:course, title: "Math", author: old_author) }
  let!(:programming_course) { create(:course, title: "Programming", author: old_author) }

  shared_examples "error" do |err_msg|
    it "does not update courses author and returns error" do
      expect do
        expect(result).to be_error
        expect(result.message).to eq err_msg
      end.to(
        not_change { math_course.reload.author }
          .and(not_change { programming_course.reload.author })
      )
    end
  end

  context "when new author is not provided" do
    let(:new_author) { nil }

    context "when there are no other authors" do
      before do
        create_list(:author, 2)
      end

      it "reassigns old author courses to random author" do
        expect do
          expect(result).to be_success
        end.to(
          change { math_course.reload.author }
            .and(change { programming_course.reload.author })
        )
      end

      context "when author reassignment fails" do
        before do
          allow_any_instance_of(Course).to receive(:update).and_return(false)
          allow_any_instance_of(Course).to receive_message_chain(:errors, :full_messages).and_return(["err msg"])
        end

        it_behaves_like "error", "err msg"
      end
    end

    context "when there are no other authors" do
      it_behaves_like "error", "Couln't find new author to reassign courses to"
    end
  end

  context "when new author is provided" do
    let(:new_author) { create(:author) }

    it "reassigns old author's courses to provided author" do
      expect do
        expect(result).to be_success
      end.to(
        change { math_course.reload.author }.from(old_author).to(new_author)
          .and(change { programming_course.reload.author }.from(old_author).to(new_author))
      )
    end

    context "when author reassignment fails" do
      before do
        allow_any_instance_of(Course).to receive(:update).and_return(false)
        allow_any_instance_of(Course).to receive_message_chain(:errors, :full_messages).and_return(["err msg"])
      end

      it_behaves_like "error", "err msg"
    end
  end
end
