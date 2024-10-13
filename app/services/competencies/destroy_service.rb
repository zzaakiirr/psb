# frozen_string_literal: true

module Competencies
  class DestroyService < BaseService
    attr_reader :competency

    def initialize(competency)
      super()

      @competency = competency
    end

    def execute
      if competency.destroy
        success(payload: { competency: competency })
      else
        error(message: error_message_for(competency))
      end
    end
  end
end
