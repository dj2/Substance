# frozen_string_literal: true

require 'redcarpet'
require 'octicons'

# Application Helper
module ApplicationHelper
  def to_html(source)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML, autolink: true, tables: true
    )

    markdown.render(source).html_safe # rubocop:disable Rails/OutputSafety
  end

  def icon(name, opts = {})
    Octicons::Octicon.new(name, opts).to_svg.html_safe # rubocop:disable Rails/OutputSafety
  end
end
