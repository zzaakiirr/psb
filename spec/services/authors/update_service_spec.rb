# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authors::UpdateService, "#execute" do
  subject(:result) { described_class.new(author: author, params: params).execute }

  let(:author) { create(:author, name: "old_name", surname: "old_surname", patronymic: "old_patronymic") }

  context "without any params" do
    let(:params) { {} }

    it "does not update user and returns success" do
      expect do
        expect(result).to be_success
      end.not_to change { author.reload }
    end
  end

  context "with too long name" do
    let(:params) { { name: "name" * 500 } }

    it "does not update author" do
      expect do
        expect(result).to be_error
        expect(result.message).to include("Name is too long")
      end.not_to change { author.reload }
    end
  end

  context "with non-permitted params" do
    let(:params) { { name: "new_name", non_permitted_param: "non-permitted" } }

    it "updates user with permitted params and returns success" do
      expect do
        expect(result).to be_success
      end.to change { author.reload.name }.from("old_name").to("new_name")
    end
  end

  context "with all params" do
    let(:params) { { name: "new_name", surname: "new_surname", patronymic: "new_patronymic" } }

    it "updates user and returns success", :aggregate_failures do
      expect do
        expect(result).to be_success
        author.reload
      end.to(
        change { author.name }.from("old_name").to(params[:name])
          .and(change { author.surname }.from("old_surname").to(params[:surname]))
            .and(change { author.patronymic }.from("old_patronymic").to(params[:patronymic]))
      )
    end
  end
end
