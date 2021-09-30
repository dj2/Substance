# frozen_string_literal: true

require 'nokogiri'
require 'cgi'

# Parses RSS and Atom feeds.
class FeedParser
  class << self
    DC = { 'dc' => 'http://purl.org/dc/elements/1.1/' }.freeze
    CONTENT = { 'content' => 'http://purl.org/rss/1.0/modules/content/' }.freeze
    ATOM = { 'xmlns' => 'http://www.w3.org/2005/Atom' }.freeze

    def parse(data)
      doc = Nokogiri::XML.parse(data.dup.force_encoding('UTF-8'))

      if !doc.xpath('//xmlns:feed/xmlns:entry', ATOM).empty?
        parse_atom_feed(doc)
      elsif !doc.xpath('//rss/channel').empty?
        parse_rss_feed(doc)
      else
        raise "unknown document format for #{data}"
      end
    end

    private

    def xpath(node, path, meta = {})
      node.xpath(path, meta).text.strip
    end

    def xpath_html(node, path, meta = {})
      CGI.unescapeHTML(node.xpath(path, meta).inner_html.strip)
    end

    def get_date(node)
      date = xpath(node, 'pubDate')
      date = xpath(node, 'dc:date', DC) if date.blank?
      date.blank? ? DateTime.now : DateTime.parse(date)
    end

    def get_rss_content(node)
      content = xpath_html(node, 'content:encoded', CONTENT)
      content = xpath_html(node, 'description') if content.blank?
      content
    end

    def build_rss_node(item)
      content = get_rss_content(item)
      {
        guid: xpath(item, 'guid'),
        title: xpath(item, 'title'),
        url: xpath(item, 'link'),
        original_content: content.strip,
        content: ReverseMarkdown.convert(content).strip,
        published_date: get_date(item)
      }
    end

    def build_atom_node(item)
      content = xpath_html(item, 'xmlns:content', ATOM)
      content = xpath_html(item, 'xmlns:summary', ATOM) if content.blank?
      {
        guid: xpath(item, 'xmlns:id', ATOM),
        title: xpath(item, 'xmlns:title', ATOM),
        url: attribute(item, 'xmlns:link', 'href', ATOM),
        original_content: content.strip,
        content: ReverseMarkdown.convert(content).strip,
        published_date: DateTime.parse(xpath(item, 'xmlns:updated', ATOM))
      }
    end

    def attribute(node, path, name, meta = {})
      node.xpath(path, meta).attribute(name).value
    end

    def parse_rss_feed(doc)
      result = { entries: [] }

      doc.xpath('//rss/channel').each do |rss|
        result[:name] = xpath(rss, '//channel/title')
        result[:description] = xpath(rss, '//channel/description')
        result[:site_url] = xpath(rss, '//channel/link')

        rss.xpath('//channel/item').each do |item|
          result[:entries] << build_rss_node(item)
        end
      end
      result
    end

    def parse_atom_feed(doc)
      result = {
        name: xpath(doc, '//xmlns:feed/xmlns:title', ATOM),
        description: xpath(doc, '//xmlns:feed/xmlns:subtitle', ATOM),
        site_url: xpath(doc, '//xmlns:feed/xmlns:id', ATOM),
        entries: []
      }

      doc.xpath('//xmlns:feed/xmlns:entry').each do |item|
        result[:entries] << build_atom_node(item)
      end
      result
    end
  end
end
