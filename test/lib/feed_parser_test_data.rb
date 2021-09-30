# frozen_string_literal: true

# Test data for Feed parser
class FeedParserTestData  # rubocop:disable Metrics/ClassLength
  RSS_FEED = <<~HERE
    <rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">
     <channel>
      <title>Feed Title</title>
      <link>https://example.com/blog/</link>
      <description>A feed description</description>
      <language>en-US</language>
      <atom:link href="https://example.com/blog/index.xml" rel="self" type="application/rss+xml"/>
      <item>
       <title>Feed Item</title>
       <link>https://example.com/blog/item1/</link>
       <pubDate>Wed, 22 Sep 2021 00:00:00 +0000</pubDate>
       <author>Item author</author>
       <guid>https://example.com/guid/item1/</guid>
       <description><p>Feed item content</p></description>
      </item>
     </channel>
    </rss>
  HERE

  RSS_WITH_CDATA = <<~HERE
    <rss xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
     <channel>
      <title>
        <![CDATA[ A Feed Title ]]>
      </title>
      <link> https://example.com </link>
      <description><![CDATA[ Feed with CDATA. ]]></description>
      <item>
       <title>
        <![CDATA[ A CDATA Item ]]>
       </title>
       <link> https://example.com/blog/cdata1/ </link>
       <guid> https://example.com/guid/cdata1/ </guid>
       <description>
        <![CDATA[ <p>A description in cdata</p> ]]>
       </description>
       <pubDate> 2021-09-23T14:00:00+00:00 </pubDate>
      </item>
     </channel>
    </rss>
  HERE

  RSS_WITH_DC_DATE = <<~HERE
    <rss xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
     <channel>
      <title>A Feed</title>
      <link> https://example.com </link>
      <description>Feed description</description>
      <dc:language> en-US </dc:language>
      <dc:creator>The dc:date folks</dc:creator>
      <dc:rights>Copyright 2021</dc:rights>
      <dc:date> 2021-09-27T22:31:24+00:00 </dc:date>
      <item>
       <title>A feed item</title>
       <author>by <a href="https://example.com/author/person/">Person</a></author>
       <link> https://example.com/blog/date1 </link>
       <guid> https://example.com/guid/date1 </guid>
       <description>
        ...
       </description>
       <dc:subject>
        ...
       </dc:subject>
       <dc:date> 2021-09-23T14:00:00+00:00 </dc:date>
      </item>
     </channel>
    </rss>
  HERE

  RSS_NO_DATE = <<~HERE
    <rss xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
     <channel>
      <title>A Feed</title>
      <link> https://example.com </link>
      <description>Feed description</description>
      <item>
       <title>A feed item</title>
       <link> https://example.com/blog/date1 </link>
       <guid> https://example.com/guid/date1 </guid>
       <description>
        ...
       </description>
      </item>
     </channel>
    </rss>
  HERE

  RSS_CONTENT_ENCODED = <<~HERE
    <?xml version="1.0" encoding="UTF-8"?>
    <rss xmlns:content="http://purl.org/rss/1.0/modules/content/">
     <channel>
      <title>Title</title>
      <description>Desc</description>
      <link>https://example.com</link>
      <item>
       <title>Title</title>
       <description>desc</description>
       <link>https://example.com/blog/content1</link>
       <guid>https://example.com/guid/content1</guid>
       <pubDate>Fri, 23 Apr 2021 18:28:24 GMT</pubDate>
       <content:encoded>content</content:encoded></item>
      </item>
     </channel>
    </rss>
  HERE

  ATOM_FEED = <<~HERE
    <feed xmlns="http://www.w3.org/2005/Atom">
     <id>https://example.com</id>
     <title>Feed Title</title>
     <subtitle>Feed description</subtitle>
     <entry>
      <title>Entry Title 1</title>
      <id>https://example.com/guid/entry1</id>
      <link href="https://example.com/blog/entry1" />
      <updated>2021-05-26T18:06:00.000Z</updated>
      <summary>Summary Text 1</summary>
      <content><p>Content text 1</p></content>
     </entry>
     <entry>
      <title>Entry Title 2</title>
      <id>https://example.com/guid/entry2</id>
      <link href="https://example.com/blog/entry2" />
      <updated>2021-05-24T18:06:00.000Z</updated>
      <summary>Summary Text 2</summary>
     </entry>
    </feed>
  HERE

  ATOM_BAD_HTML = <<~HERE
    <feed xmlns="http://www.w3.org/2005/Atom">
     <id>https://example.com</id>
     <title>Feed Title</title>
     <subtitle>Feed description</subtitle>
     <entry>
      <title>Entry Title 1</title>
      <id>https://example.com/guid/entry1</id>
      <link href="https://example.com/blog/entry1" />
      <updated>2021-05-26T18:06:00.000Z</updated>
      <content><p>Content text 1<p></content>
     </entry>
    </feed>
  HERE
end
