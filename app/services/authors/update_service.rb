# frozen_string_literal: true

module Authors
  class UpdateService < BaseService
    attr_reader :author

    def initialize(author:, params:)
      @author = author
      @params = params
    end

    def execute
      if author.update(permitted_params)
        success(payload: { author: author })
      else
        error(message: error_message_for(author))
      end
    end
  end
end
