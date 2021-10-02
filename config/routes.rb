# frozen_string_literal: true

Rails.application.routes.draw do
  get 'tags/all/:id', to: 'tags#all', as: 'all_tag'
  get 'tags/:id', to: 'tags#show', as: 'show_tag'
  get 'tags', to: 'tags#index', as: 'tags'

  get 'sync/feeds'
  get 'opml/import'
  post 'opml/import', to: 'opml#importer', as: 'opml_importer'

  get 'entries/starred', to: 'entries#starred', as: 'starred_entries'
  get 'entries/:id', to: 'entries#show', as: 'entry'
  get 'entries/:id/unread', to: 'entries#unread', as: 'unread_entry'
  get 'entries/:id/star', to: 'entries#star', as: 'star_entry'

  get 'sync/feeds', to: 'sync#feeds', as: 'feeds_sync'
  resources :feeds

  resources :notes, except: [:destroy]

  root to: 'news#index'
end
