# frozen_string_literal: true

class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
      t.string :title
      t.string :guid, unique: true
      t.string :url, unique: true
      t.string :original_content
      t.string :content
      t.datetime :published_date
      t.references :feed, null: false, foreign_key: true
      t.boolean :read, default: false
      t.boolean :starred, default: false

      t.timestamps
    end

    add_index :entries, :guid, unique: true
    add_index :entries, :url, unique: true
  end
end
