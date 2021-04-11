module Jekyll
  class TagPage < Page
    def initialize(site:, tag:, posts:)
      @site = site
      @base = site.source
      @dir = 'tag'
      @slug = Utils.slugify(tag)

      process(@slug + '.html')
      read_yaml(File.join(@base, '_layouts'), 'tag.html')
      data['title'] = tag.split
                          .map {|word| word =~ /[[:upper:]].*/ ? word : word.capitalize}
                          .join(' ')
      data['posts'] = posts
      data['tag_page'] = true
      data['permalink'] = '/:path/:basename/'
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
        TagPage.new(site: site, tag: tag, posts: posts)
      end
      site.pages.concat tag_pages
    end
  end
end
