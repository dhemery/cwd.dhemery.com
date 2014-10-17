site = OpenStruct.new(YAML::load_file(File.join('data', 'site.yaml')))
host = OpenStruct.new(YAML::load_file(File.join('data', 'host.yaml')))

Time.zone = site['timezone']

set :layout, :page
set :haml, {ugly: true}
page "/atom.xml", layout: false

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method = :rsync
  deploy.host   = host.domain
  deploy.user   = host.user
  deploy.path   = File.join(host.root, site.domain)
  deploy.flags  = '-avz -e ssh --delete'
end

activate :blog do |blog|
    blog.sources = site.post_pattern
    blog.default_extension = ".md"

    blog.layout = "post"
    blog.permalink = ":year/:month/:title"

    blog.tag_template = "tag.html"
    blog.taglink = "tag/:tag/index.html"

    blog.paginate = false
end

activate :directory_indexes

