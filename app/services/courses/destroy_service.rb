# frozen_string_literal: true

module Courses
  class DestroyService < BaseService
    attr_reader :course

    def initialize(course)
      super()

      @course = course
    end

    def execute
      if course.destroy
        success(payload: { course: course })
      else
        error(message: error_message_for(course))
      end
    end
  end
end
