# frozen_string_literal: true

class AuthorsFinder < BaseFinder
  def execute
    authors = init_collection
    authors = by_search(authors)

    by_pagination(authors)
  end

  private

  def init_collection
    Author.all
  end

  def by_search(authors)
    return authors unless params[:search]

    authors.by_search(params[:search])
  end
end
