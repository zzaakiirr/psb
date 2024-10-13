# frozen_string_literal: true

class BaseFinder
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  private

  def by_pagination(scope)
    return scope unless params[:page]

    scope = scope.page(params[:page])
    return scope unless params[:per_page]

    scope.per(params[:per_page])
  end
end
