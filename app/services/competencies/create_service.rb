# frozen_string_literal: true

module Competencies
  class CreateService < BaseService
    def execute
      competency = Competency.new(permitted_params)

      if competency.save
        success(payload: { competency: competency })
      else
        error(message: error_message_for(competency))
      end
    end
  end
end
