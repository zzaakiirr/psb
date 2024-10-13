# frozen_string_literal: true

module Competencies
  class UpdateService < BaseService
    attr_reader :competency

    def initialize(competency:, params:)
      super(params)

      @competency = competency
    end

    def execute
      if competency.update(permitted_params)
        success(payload: { competency: competency })
      else
        error(message: error_message_for(competency))
      end
    end
  end
end
