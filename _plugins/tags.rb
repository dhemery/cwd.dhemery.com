module Jekyll

  class TagPage < Page
    def initialize(site:, tag:, posts:)
      @site = site
      @base = site.source
      @dir = 'tag'
      @name = Utils::slugify(tag)

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'tag.html')
      self.data['title'] = tag
      self.data['posts'] = posts
      self.data['tag_page'] = true
      self.data['permalink'] = '/:path/:basename/'
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      posts_by_tag = {}
      site.posts.docs.each do |post|
        tags = post.data['tags'] || []
        tags.each do |tag|
          posts_by_tag[tag] ||= []
          posts_by_tag[tag] << post
        end
      end
      tag_pages = posts_by_tag.map do |tag, posts|
        TagPage.new(site: site, tag: tag, posts: posts )
      end
      site.pages.concat tag_pages
    end
  end
end
