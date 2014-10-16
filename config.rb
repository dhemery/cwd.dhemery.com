site = OpenStruct.new(YAML::load_file(File.join('data', 'site.yaml')))

Time.zone = site['timezone']

set :layout, :page
set :haml, {ugly: true}
page "/atom.xml", layout: false

activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.host   = 'dhemery.com'
  deploy.user   = 'dhemery'
  deploy.path   = '/srv/sites/cwd.dhemery.com'
  deploy.flags  = '-avz -e ssh --delete'
end

helpers do
  def relativize url
    uri = URI.parse(url)
    if uri.host == data.site.domain
      uri.route_from "http://#{data.site.domain}"
    else
      uri
    end
  end
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

