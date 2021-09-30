# frozen_string_literal: true

require 'nokogiri'

# OPML parser
class OpmlParser
  class << self
    def parse(input)
      parse_nodes(Nokogiri::XML.parse(input).css('body').children)
    end

    private

    def parse_nodes(nodes, tags = [])
      feeds = []
      nodes.each do |n|
        next if n.name != 'outline'

        feeds << process_node(n, tags)
      end
      feeds.flatten
    end

    def process_node(node, tags)
      if node.children.length.positive?
        tags += [node[:title] || node[:text]]
        return parse_nodes(node.children, tags)
      end

      {
        name: node[:title] || node[:text],
        feed_url: node[:xmlUrl],
        site_url: node[:htmlUrl],
        tag_list: tags.sort.join(', ')
      }
    end
  end
end
