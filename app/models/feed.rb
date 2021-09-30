# frozen_string_literal: true

require 'net/https'
require 'uri'

# An individual feed
class Feed < ApplicationRecord
  validates :feed_url, presence: true, uniqueness: true

  has_many :entries, dependent: :destroy, autosave: true

  acts_as_taggable_on :tags

  before_validation :update_entry_tags_if_needed

  REDIRECTS = [301, 302, 307, 308].freeze

  def unread_count
    entries.where(read: false).count
  end

  def force_sync!
    self.etag = nil
    self.last_modified = nil
    resp = sync
    save!

    resp
  end

  def sync
    resp = fetch(URI.parse(feed_url))
    return handle_redirect(resp['location']) if REDIRECTS.include?(resp.code.to_i)
    return 'no-update' if resp.code.to_i == 304

    if resp.code.to_i != 200
      Rails.logger.error("check result #{resp.code}")
      return 'fail'
    end

    process_feed(resp)
  end

  private

  def update_entry_tags_if_needed
    return unless tag_list_changed?

    entries.each do |e|
      e.tag_list.add(tag_list)
      e.save
    end
  end

  # TODO(dj2): May want to limit the depth it will follow here in case there
  #            is a loop.
  def handle_redirect(loc)
    self.feed_url = if loc.starts_with?('/')
                      uri = URI.parse(feed_url)
                      uri.path = loc
                      uri.to_s
                    else
                      loc
                    end
    sync
  end

  def fetch(uri)
    headers = { 'User-Agent' => 'Syn 0.0.1' }

    http = Net::HTTP.new(uri.host, uri.port)
    setup_ssl(http) if uri.port == 443

    headers['If-None-Match'] = etag if etag.present?
    headers['If-Modified-since'] = last_modified if last_modified.present?

    http.request(Net::HTTP::Get.new(uri.request_uri, headers))
  end

  def setup_ssl(http)
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.use_ssl = true
  end

  def known_content_type?(name)
    name =~ %r{text/xml} ||
      name =~ %r{text/plain} ||
      name =~ %r{application/atom\+xml} ||
      name =~ %r{application/rss\+xml} ||
      name =~ %r{application/xml}
  end

  def update_fetch_settings(resp)
    self.etag = resp['etag']
    self.last_modified = resp['last-modified']
    self.last_updated = Time.zone.now
  end

  def process_feed(resp)
    update_fetch_settings(resp)

    type = resp['content-type']
    return "unknown-content-type #{type}" unless known_content_type?(type)

    result = FeedParser.parse(resp.body)

    self.name = result[:name]
    self.description = result[:description]
    self.site_url = result[:site_url]

    result[:entries].each { |e| process_entry(e) }
    'ok'
  end

  def process_entry(data)
    return if Entry.where(guid: data[:guid]).present?

    entry = Entry.new(data)
    entry.tag_list = tag_list
    entries << entry
  end
end
