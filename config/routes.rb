# frozen_string_literal: true

Rails.application.routes.draw do
  get 'tags', to: 'tags#index', as: 'tags'

  get 'sync/feeds'
  get 'opml/import'
  post 'opml/import', to: 'opml#importer', as: 'opml_importer'

  get 'notes/tagged/:id', to: 'tags#show_notes', as: 'show_notes_tagged'

  get 'entries/starred', to: 'entries#starred', as: 'starred_entries'
  get 'entries/tagged/:id/all', to: 'tags#all_entries', as: 'all_entries_tagged'
  get 'entries/tagged/:id', to: 'tags#show_entries', as: 'show_entries_tagged'

  get 'entries/:id', to: 'entries#show', as: 'entry'
  get 'entries/:id/read', to: 'entries#read', as: 'read_entry'
  get 'entries/:id/unread', to: 'entries#unread', as: 'unread_entry'
  get 'entries/:id/star', to: 'entries#star', as: 'star_entry'

  get 'sync/feeds', to: 'sync#feeds', as: 'feeds_sync'
  resources :feeds

  resources :notes, except: [:destroy]

  root to: 'news#index'
end
