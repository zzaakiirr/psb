# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompetenciesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/competencies").to route_to("competencies#index")
    end

    it "routes to #show" do
      expect(get: "/competencies/1").to route_to("competencies#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/competencies").to route_to("competencies#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/competencies/1").to route_to("competencies#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/competencies/1").to route_to("competencies#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/competencies/1").to route_to("competencies#destroy", id: "1")
    end
  end
end
