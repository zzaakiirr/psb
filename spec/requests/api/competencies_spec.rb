# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Competencies API", type: :request do
  COMPETENCY_SCHEMA = {
    type: :object,
    properties: {
      id: { type: :integer },
      title: { type: :string },
      course_id: { type: :integer },
      created_at: { type: :date_time },
      updated_at: { type: :date_time }
    }
  }.freeze

  POST_RESPONSE_SCHEMA = {
    type: :object,
    properties: {
      status: { type: :string },
      message: { type: :string, nullable: true },
      payload: {
        type: :object,
        properties: {
          competency: COMPETENCY_SCHEMA
        }
      }
    },
    required: %w[status message payload]
  }.freeze

  COMPETENCY_SCHEMA_EXAMPLE = {
    id: 1,
    title: "Test competency",
    course_id: 1,
    created_at: "2024-10-11T00:00:00.000Z",
    updated_at: "2024-10-11T00:00:00.000Z"
  }.freeze

  path "/competencies" do
    let(:course) { create(:course) }

    post "Creates a competency" do
      tags "Competencies"

      consumes "application/json"
      produces "application/json"

      parameter name: :attrs, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          course_id: { type: :integer }
        },
        required: %w[title course_id]
      }

      response "201", "Competency created" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { competency: COMPETENCY_SCHEMA_EXAMPLE }
        }

        let(:attrs) { { title: "Test competency", course_id: course.id } }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          competency_data = data.fetch("payload").fetch("competency")
          expect(competency_data.fetch("title")).to eq attrs.fetch(:title)
          expect(competency_data.fetch("course_id")).to eq attrs.fetch(:course_id)
        end
      end

      response "422", "Invalid request" do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 payload: { type: :object }
               },
               required: %w[status message payload]

        example "application/json", :example, {
          status: "error",
          message: "Title can't be blank",
          payload: {}
        }

        let(:attrs) { { course_id: course.id } }

        run_test! do |response|
          expect_error_response(response, msg: "Title can't be blank")
        end
      end
    end

    get "Lists competencies" do
      tags "Competencies"

      consumes "application/json"
      produces "application/json"

      parameter name: :search, in: :query, type: :string, required: false
      parameter name: :course_id, in: :query, type: :integer, required: false
      parameter name: :page, in: :query, type: :integer, required: false, default: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, default: 25

      response "200", "Returns list of competencies with pagination" do
        schema type: :array, items: COMPETENCY_SCHEMA

        example "application/json", :example, [COMPETENCY_SCHEMA_EXAMPLE]

        let(:page) { 2 }
        let(:per_page) { 1 }

        let!(:competencies) { create_list(:competency, 3) }

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          competency_data = data.first
          expect_correct_competency_data(competency_data, competencies[1])
        end
      end

      response "200", "Returns list of course's competencies" do
        schema type: :array, items: COMPETENCY_SCHEMA

        example "application/json", :example, [COMPETENCY_SCHEMA_EXAMPLE]

        let(:course_id) { competencies[0].course_id }

        let!(:competencies) { create_list(:competency, 3) }

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          competency_data = data.first
          expect_correct_competency_data(competency_data, competencies[0])
        end
      end

      response "200", "Returns list of competencies filtered by search query" do
        schema type: :array, items: COMPETENCY_SCHEMA

        example "application/json", :example, [COMPETENCY_SCHEMA_EXAMPLE]

        let(:search) { "Ma" }

        let!(:competencies) do
          [
            create(:competency, title: "Math"),
            create(:competency, title: "Criminal Psychology")
          ]
        end

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          competency_data = data.first
          expect_correct_competency_data(competency_data, competencies[0])
        end
      end

      response "200", "Returns list of competencies" do
        schema type: :array, items: COMPETENCY_SCHEMA

        example "application/json", :example, [COMPETENCY_SCHEMA_EXAMPLE]

        let!(:competency) { create(:competency) }

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          competency_data = data.first
          expect_correct_competency_data(competency_data, competency)
        end
      end
    end
  end

  path "/competencies/{id}" do
    let(:competency) { create(:competency) }

    get "Retrieves a competency" do
      tags "Competencies"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer, required: true

      response "200", "Competency found" do
        schema(**COMPETENCY_SCHEMA, required: %w[id title course_id created_at updated_at])

        example "application/json", :example, COMPETENCY_SCHEMA_EXAMPLE

        let(:id) { competency.id }

        run_test! do |response|
          data = json_data(response)
          expect_correct_competency_data(data, competency)
        end
      end

      response "404", "Competency not found" do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string }
               },
               required: %w[status message]

        example "application/json", :example, {
          status: "error",
          message: "Record not found"
        }

        let(:id) { "invalid" }

        run_test! do |response|
          expect_error_response(response, msg: "Record not found")
        end
      end
    end

    put "Updates a competency" do
      tags "Competencies"

      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :attrs, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string, nullable: true },
          course_id: { type: :integer, nullable: true }
        }
      }

      response "200", "Competency updated" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { competency: COMPETENCY_SCHEMA_EXAMPLE }
        }

        let(:id) { competency.id }
        let(:attrs) { { title: "updated_title" } }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          competency_data = data.fetch("payload").fetch("competency")
          expect(competency_data.fetch("title")).to eq attrs.fetch(:title)
        end
      end

      response "422", "Invalid request" do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 payload: { type: :object }
               },
               required: %w[status message payload]

        example "application/json", :example, {
          status: "error",
          message: "Title can't be blank",
          payload: {}
        }

        let(:id) { competency.id }
        let(:attrs) { { title: nil } }

        run_test! do |response|
          expect_error_response(response, msg: "Title can't be blank")
        end
      end

      response "404", "Competency not found" do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string }
               },
               required: %w[status message]

        example "application/json", :example, {
          status: "error",
          message: "Record not found"
        }

        let(:id) { "invalid" }
        let(:attrs) { {} }

        run_test! do |response|
          expect_error_response(response, msg: "Record not found")
        end
      end
    end

    delete "Deletes a competency" do
      tags "Competencies"

      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true

      let(:other_competency) { create(:competency) }

      response "200", "Competency deleted" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { competency: COMPETENCY_SCHEMA_EXAMPLE }
        }

        let(:id) { competency.id }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          competency_data = data.fetch("payload").fetch("competency")
          expect(competency_data.fetch("id")).to eq(id)
        end
      end

      response "404", "Competency not found" do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string }
               },
               required: %w[status message]

        example "application/json", :example, {
          status: "error",
          message: "Record not found"
        }

        let(:id) { "invalid" }

        run_test! do |response|
          expect_error_response(response, msg: "Record not found")
        end
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def expect_correct_competency_data(data, competency)
    expect(data.fetch("id")).to eq(competency.id)
    expect(data.fetch("title")).to eq(competency.title)
    expect(data.fetch("course_id")).to eq(competency.course_id)
    expect(data.fetch("created_at")).to eq(competency.created_at.as_json)
    expect(data.fetch("updated_at")).to eq(competency.updated_at.as_json)
  end
  # rubocop:enable Metrics/AbcSize
end
