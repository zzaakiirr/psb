# frozen_string_literal: true

module Courses
  class CreateService < BaseService
    def execute
      course = Course.new(permitted_params)

      if course.save
        success(payload: { course: course })
      else
        error(message: error_message_for(course))
      end
    end
  end
end
