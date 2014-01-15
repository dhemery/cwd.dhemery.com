require 'middleman-blog'
page "/feed.xml", layout: false

configure :build do
end

activate :blog do |blog|
    blog.sources = "posts/:year-:month-:day-:title"
    blog.default_extension = ".md"

    blog.layout = "post"
    blog.permalink = ":year/:month/:title"

    blog.tag_template = "categories.html"
    blog.taglink = "category/:tag/index.html"

    blog.paginate = false
    blog.custom_collections = {
        category: {
            link: '/foo/{category}.html',
            template: '/categories.html'
        }
    }

end

activate :directory_indexes
