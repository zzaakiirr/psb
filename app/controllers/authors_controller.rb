# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :author, only: %i[show update destroy]

  def index
    authors = AuthorsFinder.new(finder_params).execute

    render json: authors
  end

  def show
    render json: author
  end

  def create
    result = Authors::CreateService.new(author_params).execute

    render_json(result, status: result.success? ? :created : :unprocessable_entity)
  end

  def update
    result = Authors::UpdateService.new(author: author, params: author_params).execute

    render_json(result, status: result.success? ? :ok : :unprocessable_entity)
  end

  def destroy
    result = Authors::DestroyService.new(author).execute(new_courses_author: new_courses_author)

    render_json(result, status: (:ok if result.success?))
  end

  private

  def new_courses_author
    new_courses_author_id = author_destroy_params[:new_courses_author_id]
    return if new_courses_author_id.nil?

    Author.find(new_courses_author_id)
  end

  def author_params
    params.permit(:name, :surname, :patronymic)
  end

  def author_destroy_params
    params.permit(:new_courses_author_id)
  end

  def finder_params
    params.slice(:search).merge(pagination_params)
  end

  def author
    @author ||= Author.find(params[:id])
  end
end
