# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authors::CreateService, "#execute" do
  subject(:result) { described_class.new(params: params).execute }

  shared_examples "returns error" do |err_msg|
    it "does not create author" do
      expect do
        expect(result).to be_error
        expect(result.message).to include(err_msg)
      end.not_to change { Author.count }
    end
  end

  context "without any params" do
    let(:params) { {} }

    it_behaves_like "returns error", "Name can't be blank"
  end

  context "with too long name" do
    let(:params) { { name: "name" * 500 } }

    it_behaves_like "returns error", "Name is too long"
  end

  context "with non-permitted params" do
    let(:params) { { name: "name", non_permitted_param: "non-permitted" } }

    it "creates user with permitted params and returns success" do
      expect do
        expect(result).to be_success
      end.to change { Author.count }.by(1)

      created_author = Author.last
      expect(created_author.name).to eq(params.fetch(:name))
      expect(created_author.surname).to be_nil
      expect(created_author.patronymic).to be_nil
    end
  end

  context "with all params" do
    let(:params) { { name: "john", surname: "doe", patronymic: "patronymic" } }

    it "creates user and returns success" do
      expect do
        expect(result).to be_success
      end.to change { Author.count }.by(1)

      created_author = Author.last
      expect(created_author.name).to eq params.fetch(:name)
      expect(created_author.surname).to eq params.fetch(:surname)
      expect(created_author.patronymic).to eq params.fetch(:patronymic)
    end
  end
end
