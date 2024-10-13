# frozen_string_literal: true

module Courses
  class UpdateService < BaseService
    attr_reader :course

    def initialize(course:, params:)
      super(params)

      @course = course
    end

    def execute
      if course.update(permitted_params)
        success(payload: { course: course })
      else
        error(message: error_message_for(course))
      end
    end
  end
end
