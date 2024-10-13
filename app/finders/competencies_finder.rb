# frozen_string_literal: true

class CompetenciesFinder < BaseFinder
  def execute
    competencies = init_collection
    competencies = by_search(competencies)
    competencies = by_course(competencies)

    by_pagination(competencies)
  end

  private

  def init_collection
    Competency.all
  end

  def by_search(competencies)
    return competencies unless params[:search]

    competencies.by_search(params[:search])
  end

  def by_course(competencies)
    return competencies unless params[:course_id]

    competencies.by_course(params[:course_id])
  end
end
