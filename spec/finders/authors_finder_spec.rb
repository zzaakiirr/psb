# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthorsFinder, "#execute" do
  subject(:authors) { described_class.new(params).execute }

  let!(:author1) { create(:author, name: "AAAbbbCCC", surname: nil, patronymic: nil) }
  let!(:author2) { create(:author, name: "DDDeeeFFF", surname: "aaBB", patronymic: nil) }
  let!(:author3) { create(:author, name: "GGG", surname: nil, patronymic: "a") }
  let!(:author4) { create(:author, name: "JJJ", surname: nil, patronymic: nil) }

  context "without any params" do
    let(:params) { {} }

    it "returns all authors" do
      expect(authors).to contain_exactly(author1, author2, author3, author4)
    end
  end

  context "with pagination params" do
    let(:params) { { page: 1, per_page: 1 } }

    it "returns paginated authors" do
      expect(authors).to contain_exactly(author1)
    end
  end

  context "with search query" do
    let(:params) { { search: "A" } }

    it "returns authors containing search query in name/surname/patronymic" do
      expect(authors).to contain_exactly(author1, author2, author3)
    end
  end
end
