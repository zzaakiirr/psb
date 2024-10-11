# frozen_string_literal: true

module Authors
  class DestroyService < BaseService
    attr_reader :author

    def initialize(author)
      super()

      @author = author
    end

    # rubocop:disable Metrics/MethodLength
    def execute(new_courses_author: nil)
      err_msg = nil

      ApplicationRecord.transaction do
        reassignment_result = ReassignCoursesService.new(old_author: author, new_author: new_courses_author).execute

        if reassignment_result.error?
          err_msg = reassignment_result.message
          raise ActiveRecord::Rollback
        end

        unless author.destroy
          err_msg = error_message_for(author)
          raise ActiveRecord::Rollback
        end
      end

      if err_msg
        error(message: err_msg)
      else
        success(payload: { author: author })
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
