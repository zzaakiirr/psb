# frozen_string_literal: true

module Authors
  class BaseService < BaseService
    PERMITTED_PARAMS = %i[name surname patronymic].freeze

    private

    def permitted_params
      params.slice(*PERMITTED_PARAMS)
    end
  end
end
