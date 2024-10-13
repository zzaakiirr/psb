# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.where_field_matches_query(field, query)
    where(arel_table[field].matches("%#{sanitize_sql_like(query)}%"))
  end

  def self.id_in(ids)
    where(id: ids)
  end
end
