# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :author, only: %i[show update destroy]

  def index
    @authors = Author.all

    render json: @authors
  end

  def show
    render json: @author
  end

  def create
    result = Authors::CreateService.new(params: author_params).execute

    if result.success?
      author = result.payload[:author]
      render json: author, status: :created, location: author
    else
      render json: result.message, status: :unprocessable_entity
    end
  end

  def update
    result = Authors::UpdateServive.new(author: author, params: author_params).execute

    if result.success?
      render json: result.payload[:author]
    else
      render json: result.message, status: :unprocessable_entity
    end
  end

  def destroy
    result = Authors::DestroyService.new(author: author).execute

    if result.success?
      render json: result.payload[:author]
    else
      render json: result.message
    end
  end

  private

  def author
    @author ||= Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :surname, :patronymic)
  end
end
