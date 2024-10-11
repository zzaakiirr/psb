# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :author, only: %i[show update destroy]

  def index
    authors = Author.page(page).per(per_page)

    render json: authors
  end

  def show
    render json: author
  end

  def create
    result = Authors::CreateService.new(author_params).execute

    if result.success?
      author = result.payload[:author]
      render json: { author: author }, status: :created, location: author
    else
      render_error(result.message)
    end
  end

  def update
    result = Authors::UpdateService.new(author: author, params: author_params).execute

    if result.success?
      render json: { author: result.payload[:author] }
    else
      render_error(result.message)
    end
  end

  def destroy
    result = Authors::DestroyService.new(author).execute(new_courses_author: new_courses_author)

    if result.success?
      render json: { author: result.payload[:author] }
    else
      render_error(result.message)
    end
  end

  private

  def new_courses_author
    new_courses_author_id = destroy_author_params[:new_courses_author_id]

    if new_courses_author_id
      Author.find(new_courses_author_id)
    else
      Author.random_author
    end
  end

  def author_params
    params.permit(:name, :surname, :patronymic)
  end

  def destroy_author_params
    params.permit(:id, :new_courses_author_id)
  end

  def author
    @author ||= Author.find(params[:id])
  end
end
