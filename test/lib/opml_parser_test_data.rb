# frozen_string_literal: true

# Test data for OPML parser
class OpmlParserTestData
  OPML_FILE = <<~HERE
    <?xml version="1.0" encoding="UTF-8"?>
    <opml version="1.1">
      <head>
        <title>Subscriptions-iCloud.opml</title>
      </head>
    <body>
      <outline text="A List Apart: The Full Feed" title="A List Apart: The Full Feed" description="" type="rss" version="RSS" htmlUrl="https://alistapart.com/" xmlUrl="https://alistapart.com/main/feed/"/>
      <outline text="Programming" title="Programming">
        <outline text="Code" title="Code">
          <outline text="Accidentally in Code" title="Accidentally in Code" description="" type="rss" version="RSS" htmlUrl="https://cate.blog/" xmlUrl="https://cate.blog/feed/"/>
        </outline>
      </outline>
      <outline text="Security" title="Security">
        <outline text="Schneier on Security" title="Schneier on Security" description="" type="rss" version="RSS" htmlUrl="https://www.schneier.com/" xmlUrl="https://www.schneier.com/feed/"/>
      </outline>
    </body>
    </opml>
  HERE
end
