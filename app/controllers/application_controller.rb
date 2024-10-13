# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_json(service_response, **kwargs)
    json_data = {
      status: service_response.status,
      payload: service_response.payload,
      message: service_response.message
    }

    render json: json_data, **kwargs
  end

  def render_not_found
    render json: { status: :error, message: "Record not found" }, status: :not_found
  end

  def pagination_params
    {
      page: params.fetch(:page, 1),
      per_page: params.fetch(:per_page, Kaminari.config.default_per_page)
    }
  end
end
