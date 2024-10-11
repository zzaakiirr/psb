# frozen_string_literal: true

module Authors
  class CreateService < BaseService
    def execute
      author = Author.new(permitted_params)

      if author.save
        success(payload: { author: author })
      else
        error(message: error_message_for(author))
      end
    end
  end
end
