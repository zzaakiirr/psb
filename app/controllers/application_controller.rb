# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render_error("Record not found", status: :not_found)
  end

  def render_error(err_msg, status: :unprocessable_entity)
    render json: { error: err_msg }, status: status
  end

  def page
    params.fetch(:page, 1)
  end

  def per_page
    params.fetch(:per_page, Kaminari.config.default_per_page)
  end
end
