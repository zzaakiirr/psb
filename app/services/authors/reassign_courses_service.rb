# frozen_string_literal: true

module Authors
  class ReassignCoursesService < BaseService
    attr_reader :old_author, :new_author

    def initialize(old_author:, new_author: nil)
      super()

      @old_author = old_author
      @new_author = new_author || find_new_random_author
    end

    def execute
      return error(message: "Couln't find new author to reassign courses to") unless new_author

      err_msg = nil

      ApplicationRecord.transaction do
        old_author.courses.each do |course|
          next if course.update(author: new_author)

          err_msg = error_message_for(course)
          raise ActiveRecord::Rollback
        end
      end

      err_msg ? error(message: err_msg) : success
    end

    def find_new_random_author
      Author.where.not(id: old_author.id).order("RANDOM()").take
    end
  end
end
