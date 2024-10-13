# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :course, only: %i[show update destroy]

  def index
    courses = Course.page(page).per(per_page)

    render json: courses
  end

  def show
    render json: course
  end

  def create
    result = Courses::CreateService.new(course_params).execute

    render_json(result, status: result.success? ? :created : :unprocessable_entity)
  end

  def update
    result = Courses::UpdateService.new(course: course, params: course_params).execute

    render_json(result, status: result.success? ? :ok : :unprocessable_entity)
  end

  def destroy
    result = Courses::DestroyService.new(course).execute

    render_json(result, status: (:ok if result.success?))
  end

  private

  def course
    @course ||= Course.find(params[:id])
  end

  def course_params
    params.permit(:title, :author_id)
  end
end
