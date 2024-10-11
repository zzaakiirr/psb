# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :surname
      t.string :patronymic

      t.timestamps
    end
  end
end
