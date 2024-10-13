# frozen_string_literal: true

module Courses
  class BaseService < BaseService
    PERMITTED_PARAMS = %i[title author_id].freeze

    private

    def permitted_params
      params.slice(*PERMITTED_PARAMS)
    end
  end
end
