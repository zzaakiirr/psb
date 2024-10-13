# frozen_string_literal: true

require "rails_helper"

RSpec.describe Competencies::DestroyService, "#execute" do
  subject(:result) { described_class.new(competency).execute }

  let!(:competency) { create(:competency) }

  it "destroys competency and returns success" do
    expect do
      expect(result).to be_success
    end.to change { Competency.count }.by(-1)

    expect(Competency.exists?(competency.id)).to eq(false)
  end

  context "when competency destruction fails" do
    before do
      allow(competency).to receive(:destroy).and_return(false)
      competency.errors.add(:base, "err msg")
    end

    it "does not destroy competency and returns error" do
      expect do
        expect(result).to be_error
        expect(result.message).to eq "err msg"
      end.not_to change { Competency.count }

      expect(Competency.exists?(competency.id)).to eq(true)
    end
  end
end
