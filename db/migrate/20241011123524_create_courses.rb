# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.references :author, null: false, foreign_key: true, index: true
      t.text :title, null: false, limit: 255

      t.timestamps
    end

    add_index :courses, %i[title author_id], unique: true
  end
end
