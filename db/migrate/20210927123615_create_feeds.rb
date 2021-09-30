# frozen_string_literal: true

class CreateFeeds < ActiveRecord::Migration[6.1]
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :description
      t.string :feed_url, unique: true
      t.string :site_url
      t.datetime :last_updated
      t.string :last_modified
      t.string :etag

      t.timestamps
    end

    add_index :feeds, :feed_url, unique: true
  end
end
