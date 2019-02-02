site_url = "http://#{data.site.domain}/"
date_format = '%Y-%m-%dT%H:%M:%S%:z'
xml.instruct! :xml, encoding: 'UTF-8'
xml.feed xmlns: 'http://www.w3.org/2005/Atom' do
  xml.title data.site.title, type: 'html'
  xml.subtitle data.site.subtitle, type: 'html'
  xml.link href: URI.join(site_url, current_page.url), rel: 'self'
  xml.link href: site_url, rel: 'alternate'
  xml.id site_url
  xml.updated blog.articles.first.date.strftime(date_format)
  xml.rights data.site.copyright, type: 'html'
  xml.author do
    xml.name data.site.author.name
    xml.email data.site.author.email
  end
  blog.articles[0..10].each do |post|
    xml.entry do
      xml.title post.title, type: 'html'
      xml.id URI.join(site_url, post.url)
      xml.link href: post.url, rel: 'alternate'
      post.tags.each do |tag|
        xml.category term: tag
      end
      xml.updated post.date.strftime(date_format)
      xml.content post.body, type: 'html'
    end
  end
end
