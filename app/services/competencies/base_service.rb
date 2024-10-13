# frozen_string_literal: true

module Competencies
  class BaseService < BaseService
    PERMITTED_PARAMS = %i[title course_id].freeze

    private

    def permitted_params
      params.slice(*PERMITTED_PARAMS)
    end
  end
end
