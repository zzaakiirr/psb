# frozen_string_literal: true

class BaseService
  include ReturnsServiceResponse

  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  private

  def error_message_for(object)
    object.errors.full_messages.to_sentence
  end
end
