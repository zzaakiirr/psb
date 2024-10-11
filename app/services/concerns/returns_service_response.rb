# frozen_string_literal: true

module ReturnsServiceResponse
  extend ActiveSupport::Concern

  included do
    delegate :success, :error, to: ServiceResponse, private: true
  end
end
