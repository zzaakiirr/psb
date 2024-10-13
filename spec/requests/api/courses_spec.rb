# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Courses API", type: :request do
  COURSE_SCHEMA = {
    type: :object,
    properties: {
      id: { type: :integer },
      title: { type: :string },
      author_id: { type: :integer },
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
          course: COURSE_SCHEMA
        }
      }
    },
    required: %w[status message payload]
  }.freeze

  COURSE_SCHEMA_EXAMPLE = {
    id: 1,
    title: "Test course",
    author_id: 1,
    created_at: "2024-10-11T00:00:00.000Z",
    updated_at: "2024-10-11T00:00:00.000Z"
  }.freeze

  path "/courses" do
    let(:author) { create(:author) }

    post "Creates a course" do
      tags "Courses"

      consumes "application/json"
      produces "application/json"

      parameter name: :attrs, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          author_id: { type: :integer }
        },
        required: %w[title author_id]
      }

      response "201", "Course created" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { course: COURSE_SCHEMA_EXAMPLE }
        }

        let(:attrs) { { title: "Test course", author_id: author.id } }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          course_data = data.fetch("payload").fetch("course")
          expect(course_data.fetch("title")).to eq attrs.fetch(:title)
          expect(course_data.fetch("author_id")).to eq attrs.fetch(:author_id)
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

        let(:attrs) { { author_id: author.id } }

        run_test! do |response|
          expect_error_response(response, msg: "Title can't be blank")
        end
      end
    end

    get "Lists all courses" do
      tags "Courses"

      consumes "application/json"
      produces "application/json"

      parameter name: :page, in: :query, type: :integer, required: false, default: 1
      parameter name: :per_page, in: :query, type: :integer, required: false, default: 25

      response "200", "Returns list of courses" do
        schema type: :array, items: COURSE_SCHEMA

        example "application/json", :example, [COURSE_SCHEMA_EXAMPLE]

        let!(:course) { create(:course) }

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          course_data = data.first
          expect_correct_course_data(course_data, course)
        end
      end

      response "200", "Returns list of courses with pagination" do
        schema type: :array, items: COURSE_SCHEMA

        example "application/json", :example, [COURSE_SCHEMA_EXAMPLE]

        let(:page) { 2 }
        let(:per_page) { 1 }

        let!(:courses) { create_list(:course, 3) }

        run_test! do |response|
          data = json_data(response)
          expect(data.count).to eq(1)

          course_data = data.first
          expect_correct_course_data(course_data, courses[1])
        end
      end
    end
  end

  path "/courses/{id}" do
    let(:course) { create(:course) }

    get "Retrieves a course" do
      tags "Courses"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer, required: true

      response "200", "Course found" do
        schema(**COURSE_SCHEMA, required: %w[id title author_id created_at updated_at])

        example "application/json", :example, COURSE_SCHEMA_EXAMPLE

        let(:id) { course.id }

        run_test! do |response|
          data = json_data(response)
          expect_correct_course_data(data, course)
        end
      end

      response "404", "Course not found" do
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

    put "Updates a course" do
      tags "Courses"

      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :attrs, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string, nullable: true },
          author_id: { type: :integer, nullable: true },
        }
      }

      response "200", "Course updated" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { course: COURSE_SCHEMA_EXAMPLE }
        }

        let(:id) { course.id }
        let(:attrs) { { title: "updated_title" } }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          course_data = data.fetch("payload").fetch("course")
          expect(course_data.fetch("title")).to eq attrs.fetch(:title)
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

        let(:id) { course.id }
        let(:attrs) { { title: nil } }

        run_test! do |response|
          expect_error_response(response, msg: "Title can't be blank")
        end
      end

      response "404", "Course not found" do
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

    delete "Deletes a course and reassigns his courses to other course" do
      tags "Courses"

      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true

      let(:other_course) { create(:course) }

      response "200", "Course deleted" do
        schema(**POST_RESPONSE_SCHEMA)

        example "application/json", :example, {
          status: "success",
          message: nil,
          payload: { course: COURSE_SCHEMA_EXAMPLE }
        }

        let(:id) { course.id }

        run_test! do |response|
          data = json_data(response)

          expect(data.fetch("status")).to eq("success")
          expect(data.fetch("message")).to be_nil

          course_data = data.fetch("payload").fetch("course")
          expect(course_data.fetch("id")).to eq(id)
        end
      end

      response "404", "Course not found" do
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
  def expect_correct_course_data(data, course)
    expect(data.fetch("id")).to eq(course.id)
    expect(data.fetch("title")).to eq(course.title)
    expect(data.fetch("author_id")).to eq(course.author_id)
    expect(data.fetch("created_at")).to eq(course.created_at.as_json)
    expect(data.fetch("updated_at")).to eq(course.updated_at.as_json)
  end
  # rubocop:enable Metrics/AbcSize
end
