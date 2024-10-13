# frozen_string_literal: true

class CompetenciesController < ApplicationController
  before_action :competency, only: %i[show update destroy]

  def index
    competencies = Competency.page(page).per(per_page)

    render json: competencies
  end

  def show
    render json: competency
  end

  def create
    result = Competencies::CreateService.new(competency_params).execute

    render_json(result, status: result.success? ? :created : :unprocessable_entity)
  end

  def update
    result = Competencies::UpdateService.new(competency: competency, params: competency_params).execute

    render_json(result, status: result.success? ? :ok : :unprocessable_entity)
  end

  def destroy
    result = Competencies::DestroyService.new(competency).execute

    render_json(result, status: (:ok if result.success?))
  end

  private

  def competency
    @competency ||= Competency.find(params[:id])
  end

  def competency_params
    params.permit(:title, :course_id)
  end
end
