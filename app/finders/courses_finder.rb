# frozen_string_literal: true

class CoursesFinder < BaseFinder
  def execute
    courses = init_collection
    courses = by_search(courses)
    courses = by_author(courses)

    by_pagination(courses)
  end

  private

  def init_collection
    Course.all
  end

  def by_search(courses)
    return courses unless params[:search]

    courses.by_search(params[:search])
  end

  def by_author(courses)
    return courses unless params[:author_id]

    courses.by_author(params[:author_id])
  end
end
