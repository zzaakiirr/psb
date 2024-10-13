# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Authors API", type: :request do
  AUTHOR_SCHEMA = {
    type: :object,
    properties: {
      id: { type: :integer },
      name: { type: :string },
      surname: { type: :string, nullable: true },
      patronymic: { type: :string, nullable: true },
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
          author: AUTHOR_SCHEMA
        }
      }
    },
    required: %w[status message payload]
  }.freeze

  AUTHOR_SCHEMA_EXAMPLE = {
    id: 1,
    name: "john",
    surname: "doe",
    patronymic: "patronymic",
    created_at: "2024-10-11T00:00:00.000Z",
    updated_at: "2024-10-11T00:00:00.000Z"
  }.freeze

  path "/authors" do
    post "Creates an author" do
      tags "Authors"

      consumes "application/json"
      produces "application/json"

      parameter name: :attrs, in: :body, required: true, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          surname: { type: :string, nullable: true },
          patronymic: { type: :string, nullable: true }
        },
        required: %w[name surname]
      }

      response "201", "Author created" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { author: AUTHOR_SCHEMA_EXAMPLE }
        }

        let(:attrs) { { name: "john", surname: "doe" } }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          author_data = data.fetch("payload").fetch("author")
          expect(author_data.fetch("surname")).to eq attrs.fetch(:surname)
          expect(author_data.fetch("patronymic")).to be_nil
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
          message: "Name can't be blank",
          payload: {}
        }

        let(:attrs) { { surname: "doe" } }

        run_test! do |response|
          expect_error_response(response, msg: "Name can't be blank")
        end
      end
    end

    get "Lists authors" do
      tags "Authors"

      consumes "application/json"
      produces "application/json"

      parameter name: :page, in: :query, type: :integer, required: false, default: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, default: 25

      response "200", "Returns list of authors" do
        schema type: :array, items: AUTHOR_SCHEMA

        example "application/json", :example, [AUTHOR_SCHEMA_EXAMPLE]

        let!(:author) { create(:author) }

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          author_data = data.first
          expect_correct_author_data(author_data, author)
        end
      end

      response "200", "Returns list of authors with pagination" do
        schema type: :array, items: AUTHOR_SCHEMA

        example "application/json", :example, [AUTHOR_SCHEMA_EXAMPLE]

        let(:page) { 2 }
        let(:per_page) { 1 }

        let!(:authors) { create_list(:author, 3) }

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          author_data = data.first
          expect_correct_author_data(author_data, authors[1])
        end
      end
    end
  end

  path "/authors/{id}" do
    let(:author) { create(:author) }

    get "Retrieves an author" do
      tags "Authors"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer, required: true

      response "200", "Author found" do
        schema(**AUTHOR_SCHEMA, required: %w[id name surname patronymic created_at updated_at])

        example "application/json", :example, AUTHOR_SCHEMA_EXAMPLE

        let(:id) { author.id }

        run_test! do |response|
          data = json_data(response)
          expect_correct_author_data(data, author)
        end
      end

      response "404", "Author not found" do
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

    put "Updates an author" do
      tags "Authors"

      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :attrs, in: :body, required: true, schema: {
        type: :object,
        properties: {
          name: { type: :string, nullable: true },
          surname: { type: :string, nullable: true },
          patronymic: { type: :string, nullable: true }
        }
      }

      response "200", "Author updated" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { author: AUTHOR_SCHEMA_EXAMPLE }
        }

        let(:id) { author.id }
        let(:attrs) { { name: "updated_name" } }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          author_data = data.fetch("payload").fetch("author")
          expect(author_data.fetch("name")).to eq attrs.fetch(:name)
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
          message: "Name can't be blank",
          payload: {}
        }

        let(:id) { author.id }
        let(:attrs) { { name: nil } }

        run_test! do |response|
          expect_error_response(response, msg: "Name can't be blank")
        end
      end

      response "404", "Author not found" do
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

    delete "Deletes an author and reassigns his courses to other author" do
      tags "Authors"

      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :new_courses_author_id,
                in: :query,
                type: :integer,
                required: false,
                description: "Id of the author to reassign current author's courses"

      let(:other_author) { create(:author) }

      response "200", "Author deleted" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { author: AUTHOR_SCHEMA_EXAMPLE }
        }

        let(:id) { author.id }
        let(:new_courses_author_id) { other_author.id }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          author_data = data.fetch("payload").fetch("author")
          expect(author_data.fetch("id")).to eq(id)
        end
      end

      response "404", "Author not found" do
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
        let(:new_courses_author_id) { other_author.id }

        run_test! do |response|
          expect_error_response(response, msg: "Record not found")
        end
      end

      response "404", "New courses author not found" do
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

        let(:id) { author.id }
        let(:new_courses_author_id) { "invalid" }

        run_test! do |response|
          expect_error_response(response, msg: "Record not found")
        end
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def expect_correct_author_data(data, author)
    expect(data.fetch("id")).to eq(author.id)
    expect(data.fetch("name")).to eq(author.name)
    expect(data.fetch("surname")).to eq(author.surname)
    expect(data.fetch("patronymic")).to eq(author.patronymic)
    expect(data.fetch("created_at")).to eq(author.created_at.as_json)
    expect(data.fetch("updated_at")).to eq(author.updated_at.as_json)
  end
  # rubocop:enable Metrics/AbcSize
end
