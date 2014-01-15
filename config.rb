require 'middleman-blog'
page "/feed.xml", layout: false

configure :build do
end

activate :blog do |blog|
    blog.sources = "posts/:year-:month-:title"
    blog.default_extension = ".md"

    blog.layout = "post"
    blog.permalink = ":year/:month/:title"

    blog.tag_template = "tag.html"
    blog.taglink = "tag/:tag/index.html"

    blog.paginate = false
end

activate :directory_indexes
