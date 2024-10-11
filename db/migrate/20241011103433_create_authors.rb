# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.text :name, null: false, limit: 255
      t.text :surname, null: true, limit: 255
      t.text :patronymic, null: true, limit: 255

      t.timestamps
    end
  end
end
