# frozen_string_literal: true

class CreateCompetencies < ActiveRecord::Migration[7.1]
  def change
    create_table :competencies do |t|
      t.references :course, null: true, foreign_key: true, index: true
      t.text :title, null: false, limit: 255, index: { unique: true }

      t.timestamps
    end
  end
end
